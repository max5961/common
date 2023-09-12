// This script erases all content from function declarations inside of a specified folder

// This is designed to be used in a Webpack directory in conjuction with Jest to create an assesment of knowledge
// Once the assesment has been completed, run the script to remove the contents of all function declarations
// This way the test can be retaken but without needing to remember the exact spelling of the function names associated with the Jest tests

// *** make sure to change the path/to/directory in the path.join call to the desired directory
const fs = require('fs');
const path = require('path');

// replace '../src/algorithms with the path/to/directory that contains the files you would the script to operate on'
const targetDir = path.join(__dirname, '../src/algorithms');

fs.readdir(targetDir, (err, files) => {
  if (err) {
    console.error('unable to read directory contents:', err);
    return;
  }

  files.foreach(file => {
    const filePath = path.join(targetDir, file);
    const content = fs.readfilesync(filePath, 'utf8');

    const clearedContent = content.replace(/(function \w+\(.*\)|\w+ = \(.*\)\s*=>)\s*{[^}]*}/g, '$1 => {}');

    fs.writefilesync(filePath, clearedContent);
  });

  console.log("function contents been cleared");
});


