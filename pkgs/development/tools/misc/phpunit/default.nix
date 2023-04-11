{ lib, fetchFromGitHub, php }:

php.buildComposerProject (finalAttrs: {
  pname = "phpunit";
  version = "10.2.2";

  src = fetchFromGitHub {
    owner = "sebastianbergmann";
    repo = "phpunit";
    rev = finalAttrs.version;
    hash = "sha256-FbtTK55OnQvKeMJHkJZvOrlbQoL3wxkCzdL8ieRAS4w=";
  };

  # TODO: Open a PR against https://github.com/sebastianbergmann/phpunit
  # Missing `composer.lock` from the repository.
  composerLock = ./composer.lock;
  vendorHash = "sha256-hI8Z8glR5KOnc0/QpjfrbKdamve+X4AP4XMzgrzy4C0=";

  meta = {
    description = "PHP Unit Testing framework";
    license = lib.licenses.bsd3;
    homepage = "https://phpunit.de";
    changelog = "https://github.com/sebastianbergmann/phpunit/blob/${finalAttrs.version}/ChangeLog-${lib.versions.majorMinor finalAttrs.version}.md";
    maintainers = [ lib.maintainers.onny ] ++ lib.teams.php.members;
  };
})
