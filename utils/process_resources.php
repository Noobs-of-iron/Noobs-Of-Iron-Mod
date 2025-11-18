<?php

// Define the multiplier constant
define('MULTIPLIER', 12);

// Check command-line arguments
if ($argc < 2) {
    echo "Usage: php process_resources.php [-r] <path/*.txt>\n";
    exit(1);
}

// Function to process each file
function processFile($file) {
    $content = file_get_contents($file);

    // Process `add_resource` blocks
    $patternAddResource = '/(add_resource = \{.*?\})/s';
    $callbackAddResource = function($matches) {
        $block = $matches[1];
        
        // Check if the block contains `type = oil`
        if (strpos($block, 'type = oil') === false) {
            // Multiply the amount values by MULTIPLIER
            $block = preg_replace_callback(
                '/(\s*amount\s*=\s*)(\d+)/',
                function($amountMatches) {
                    return $amountMatches[1] . ($amountMatches[2] * MULTIPLIER);
                },
                $block
            );
        }
        
        return $block;
    };
    $content = preg_replace_callback($patternAddResource, $callbackAddResource, $content);

    // Process `resources = { ... }` blocks
    $patternResources = '/resources\s*=\s*\{([^}]*)\}/s';
    $callbackResources = function($matches) {
        $resourcesBlock = $matches[1];
        
        // Multiply values except for `oil`
        $resourcesBlock = preg_replace_callback(
            '/(\s*)([a-zA-Z_]+)\s*=\s*(\d+)(\s*#.*)?/',
            function($resourceMatches) {
                $resourceName = $resourceMatches[2];
                $resourceValue = $resourceMatches[3];
                $comment = $resourceMatches[4] ?? '';


                // Multiply the value if it's not `oil`
                if ($resourceName === 'oil') {
                    return $resourceMatches[1] . $resourceName . ' = ' . $resourceValue . $comment;
                }
                return $resourceMatches[1] . $resourceName . ' = ' . ($resourceValue * MULTIPLIER) . $comment;
            },
            $resourcesBlock
        );
        
        return 'resources={' . $resourcesBlock . '}';
    };
    $content = preg_replace_callback($patternResources, $callbackResources, $content);

    // Write the modified content back to the file
    file_put_contents($file, $content);

    echo "Processing completed for file: $file\n";
}

// Function to process files in a directory recursively
function processDirectory($dir) {
    $iterator = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($dir));
    foreach ($iterator as $fileinfo) {
        if ($fileinfo->isFile() && $fileinfo->getExtension() === 'txt') {
            processFile($fileinfo->getPathname());
        }
    }
}

// Process command-line arguments
$isRecursive = false;
$patterns = [];

for ($i = 1; $i < $argc; $i++) {
    if ($argv[$i] === '-r') {
        $isRecursive = true;
    } else {
        $patterns[] = $argv[$i];
    }
}

foreach ($patterns as $pattern) {
    if ($isRecursive) {
        processDirectory($pattern);
    } else {
        foreach (glob($pattern) as $file) {
            processFile($file);
        }
    }
}
?>
