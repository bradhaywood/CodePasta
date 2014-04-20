use strict;
use warnings;

use CodePasta;

my $app = CodePasta->apply_default_middlewares(CodePasta->psgi_app);
$app;

