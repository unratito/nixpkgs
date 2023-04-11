{ fetchFromGitHub, lib, php }:

php.buildComposerProject (finalAttrs: {
  pname = "phpstan";
  version = "1.10.21";

  src = fetchFromGitHub {
    owner = "phpstan";
    repo = "phpstan-src";
    rev = finalAttrs.version;
    hash = "sha256-oD9YUtAPF6+K3EpCSGhqsZ9nCcV6nbdyLujJRHytA7Y=";
  };

  vendorHash = "sha256-gkVgeoS5gLq7xQdBIDlzBQULTYCawvGFNRD6FG++lJU=";

  meta = {
    changelog = "https://github.com/phpstan/phpstan/releases/tag/${finalAttrs.version}";
    description = "PHP Static Analysis Tool";
    longDescription = ''
      PHPStan focuses on finding errors in your code without actually
      running it. It catches whole classes of bugs even before you write
      tests for the code. It moves PHP closer to compiled languages in the
      sense that the correctness of each line of the code can be checked
      before you run the actual line.
    '';
    license = lib.licenses.mit;
    homepage = "https://github.com/phpstan/phpstan";
    maintainers = lib.teams.php.members;
  };
})
