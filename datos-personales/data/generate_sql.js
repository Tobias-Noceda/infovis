const fs = require('fs');
const path = require('path');
const readline = require('readline');

/**
 * Escapes single quotes in SQL strings
 * @param {string} str - The string to escape
 * @returns {string} - Escaped string
 */
function escapeSqlString(str) {
  if (!str) return '';
  return str.replace(/'/g, "''");
}

/**
 * Parses a CSV line (handles quoted fields)
 * @param {string} line - The CSV line
 * @returns {string[]} - Array of fields
 */
function parseCsvLine(line) {
  const fields = [];
  let current = '';
  let insideQuotes = false;

  for (let i = 0; i < line.length; i++) {
    const char = line[i];

    if (char === '"') {
      if (insideQuotes && line[i + 1] === '"') {
        current += '"';
        i++;
      } else {
        insideQuotes = !insideQuotes;
      }
    } else if (char === ',' && !insideQuotes) {
      fields.push(current);
      current = '';
    } else {
      current += char;
    }
  }

  fields.push(current);
  return fields;
}

/**
 * Generates SQL script from artist_genre.csv
 */
async function generateSqlScript() {
  const inputFile = path.join(__dirname, 'artist_genre.csv');
  const outputFile = path.join(__dirname, 'mis_artistas_total.sql');

  const sqlLines = [];
  let isFirstLine = true;
  let rowCount = 0;

  // Add table creation statement
  sqlLines.push('-- Drop table if exists (optional, uncomment if needed)');
  sqlLines.push('DROP TABLE IF EXISTS mis_artistas_total;');
  sqlLines.push('');
  sqlLines.push('-- Create table mis_artistas_total');
  sqlLines.push('CREATE TABLE IF NOT EXISTS mis_artistas_total (');
  sqlLines.push('  id SERIAL PRIMARY KEY,');
  sqlLines.push('  artistName VARCHAR(255) NOT NULL,');
  sqlLines.push('  genre VARCHAR(255)');
  sqlLines.push(');');
  sqlLines.push('');
  sqlLines.push('-- Clear existing data (optional, uncomment if needed)');
  sqlLines.push('-- TRUNCATE TABLE mis_artistas_total;');
  sqlLines.push('');
  sqlLines.push('-- Insert data');
  sqlLines.push('INSERT INTO mis_artistas_total (artistName, genre) VALUES');

  return new Promise((resolve, reject) => {
    const rl = readline.createInterface({
      input: fs.createReadStream(inputFile),
      crlfDelay: Infinity
    });

    rl.on('line', (line) => {
      if (isFirstLine) {
        isFirstLine = false;
        return; // Skip header
      }

      const row = parseCsvLine(line);
      if (row.length >= 1 && row[0].trim()) {
        const artistName = row[0].trim();
        const genre = row[1] ? row[1].trim() : '';

        // Build INSERT statement
        const genreValue = genre === '' ? 'NULL' : `'${escapeSqlString(genre)}'`;
        const insertStatement = `('${escapeSqlString(artistName)}', ${genreValue}),`;
        
        sqlLines.push(insertStatement);
        rowCount++;
      }
    });

    rl.on('close', () => {
      // Replace last comma with semicolon
      if (rowCount > 0) {
        sqlLines[sqlLines.length - 1] = sqlLines[sqlLines.length - 1].slice(0, -1) + ';';
      } else {
        // If no rows, remove the INSERT statement
        sqlLines.splice(sqlLines.findIndex(line => line.startsWith('INSERT INTO')), 1);
      }

      sqlLines.push('');
      sqlLines.push(`-- Total rows inserted: ${rowCount}`);
      sqlLines.push('SELECT COUNT(*) as total_artists FROM mis_artistas_total;');

      fs.writeFileSync(outputFile, sqlLines.join('\n'), 'utf8');
      console.log(`✓ SQL script generated successfully!`);
      console.log(`✓ Output: ${outputFile}`);
      console.log(`✓ Total INSERT statements: ${rowCount}`);
      resolve();
    });

    rl.on('error', reject);
  });
}

// Run the generator
generateSqlScript().catch(err => {
  console.error('Error:', err);
  process.exit(1);
});
