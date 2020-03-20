<?php

use joshtronic\LoremIpsum;
use Alfred\Workflows\Workflow;

require __DIR__ . '/vendor/autoload.php';

$lipsum = new LoremIpsum;
$workflow = new Workflow;

$type = $argv[1];
$count = trim($argv[2]);

if ($count === '') {
    switch ($type) {
        case 'words': $count = 7; break;
        case 'sentences': $count = 3; break;
        case 'paragraphs': $count = 3; break;
        // TODO: lists
    }
}

if (! ctype_digit((string) $count)) {
    $workflow->result()
        ->title('Invalid Number')
        ->icon('error.png')
        ->valid(false);

    echo $workflow->output();
    exit;
}

$lipsum->word(1);

$arg = ucfirst($lipsum->{$type}($count));

$noun = $count > 1 ? $type : substr($type, 0, -1);

$workflow->result()
    ->uid('lorem-words')
    ->title(ucfirst($type))
    ->subtitle("Generate {$count} {$noun}...")
    ->arg($arg)
    ->text('copy', $arg)
    ->text('largetype', $arg)
    ->valid(true);

echo $workflow->output();
