.phony: codex codex-beta

codex:
	ansible-playbook codex.yml --ask-pass

codex-beta:
	ansible-playbook codex-beta.yml --ask-pass
