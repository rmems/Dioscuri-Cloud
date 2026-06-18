"""
Tests for the .gitlab-ci.yml changes introduced in this PR.

Changes under test:
  - Addition of the 'duo-review' stage
  - Addition of the 'gitlab-duo-review' job (image, rules, variables,
    allow_failure, when, script content)
  - Preservation of the existing 'validate' stage and workflow rules

Run with:
    python -m pytest tests/ci/test_gitlab_ci.py -v
    # or, without pytest:
    python tests/ci/test_gitlab_ci.py
"""

import os
import sys
import unittest

try:
    import yaml
except ImportError:  # pragma: no cover
    sys.exit("PyYAML is required: pip install pyyaml")

_REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
_CI_FILE = os.path.join(_REPO_ROOT, ".gitlab-ci.yml")


def _load_ci() -> dict:
    with open(_CI_FILE, encoding="utf-8") as fh:
        return yaml.safe_load(fh)


class TestStages(unittest.TestCase):
    """The 'duo-review' stage must be added while keeping 'validate'."""

    def setUp(self):
        self.ci = _load_ci()

    def test_validate_stage_still_present(self):
        self.assertIn("validate", self.ci["stages"])

    def test_duo_review_stage_added(self):
        self.assertIn("duo-review", self.ci["stages"])

    def test_stage_order_validate_before_duo_review(self):
        stages = self.ci["stages"]
        self.assertLess(
            stages.index("validate"),
            stages.index("duo-review"),
            "validate stage must come before duo-review",
        )

    def test_exactly_two_stages(self):
        # Regression: no unintended stages crept in.
        self.assertEqual(len(self.ci["stages"]), 2)


class TestWorkflowRules(unittest.TestCase):
    """The top-level workflow rules must still cover both push and MR events."""

    def setUp(self):
        self.rules = _load_ci()["workflow"]["rules"]

    def _rule_conditions(self):
        return [r.get("if", "") for r in self.rules]

    def test_main_branch_rule_present(self):
        conditions = self._rule_conditions()
        self.assertTrue(
            any('CI_COMMIT_BRANCH == "main"' in c for c in conditions),
            "Workflow must trigger on pushes to main",
        )

    def test_merge_request_event_rule_present(self):
        conditions = self._rule_conditions()
        self.assertTrue(
            any('CI_PIPELINE_SOURCE == "merge_request_event"' in c for c in conditions),
            "Workflow must trigger on merge-request events",
        )


class TestGitlabDuoReviewJob(unittest.TestCase):
    """The new 'gitlab-duo-review' job must have the correct configuration."""

    def setUp(self):
        self.ci = _load_ci()
        self.job = self.ci["gitlab-duo-review"]

    def test_job_exists(self):
        self.assertIn("gitlab-duo-review", self.ci)

    def test_job_assigned_to_duo_review_stage(self):
        self.assertEqual(self.job["stage"], "duo-review")

    def test_job_uses_duo_workflow_executor_image(self):
        self.assertEqual(
            self.job["image"],
            "registry.gitlab.com/gitlab-org/duo-workflow-executor:latest",
        )

    def test_job_allow_failure_is_true(self):
        # The job must not block the pipeline when the Duo token is absent.
        self.assertIs(self.job.get("allow_failure"), True)

    def test_job_when_is_manual(self):
        # The job must be manually triggered to avoid consuming Duo trial quota
        # on every MR automatically.
        self.assertEqual(self.job.get("when"), "manual")

    def test_job_only_runs_on_merge_request_events(self):
        rules = self.job["rules"]
        self.assertTrue(len(rules) >= 1, "Job must have at least one rule")
        mr_rule = rules[0]
        self.assertIn(
            'CI_PIPELINE_SOURCE == "merge_request_event"',
            mr_rule.get("if", ""),
        )
        self.assertEqual(mr_rule.get("when"), "always")

    def test_job_references_gitlab_token_variable(self):
        job_vars = self.job.get("variables", {})
        self.assertIn("GITLAB_TOKEN", job_vars)

    def test_job_references_duo_workflow_token_variable(self):
        job_vars = self.job.get("variables", {})
        self.assertIn("DUO_WORKFLOW_TOKEN", job_vars)

    def test_script_contains_duo_workflow_run_command(self):
        script_text = "\n".join(self.job["script"])
        self.assertIn("duo-workflow run", script_text)

    def test_script_passes_source_branch_argument(self):
        script_text = "\n".join(self.job["script"])
        self.assertIn("--source-branch", script_text)

    def test_script_passes_target_branch_argument(self):
        script_text = "\n".join(self.job["script"])
        self.assertIn("--target-branch", script_text)

    def test_script_passes_merge_request_id_argument(self):
        script_text = "\n".join(self.job["script"])
        self.assertIn("--merge-request-id", script_text)

    def test_script_targets_terraform_review(self):
        # The workflow target must be review_terraform_changes so that the Duo
        # agent applies the correct review context.
        script_text = "\n".join(self.job["script"])
        self.assertIn("review_terraform_changes", script_text)

    def test_script_has_graceful_fallback_when_token_absent(self):
        # When the token is not configured the script must fall back gracefully
        # rather than failing the job (allow_failure also covers this, but the
        # explicit '|| echo ...' documents intent).
        script_text = "\n".join(self.job["script"])
        self.assertIn("Duo agent review skipped", script_text)


class TestGlobalVariables(unittest.TestCase):
    """Global variables section must still declare TF_VERSION."""

    def setUp(self):
        self.variables = _load_ci().get("variables", {})

    def test_tf_version_declared(self):
        self.assertIn("TF_VERSION", self.variables)

    def test_tf_version_value(self):
        self.assertEqual(self.variables["TF_VERSION"], "1.10.5")


if __name__ == "__main__":
    unittest.main(verbosity=2)
