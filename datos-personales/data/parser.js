const fs = require('fs');
const path = require('path');
const readline = require('readline');

// Tags to skip (should be ignored)
const tagsToSkip = [
  'vocalist', 'mexico', 'icelandic', 'singer', 'spanish', 'italian', 'argentina',
  'colombia', 'UK', 'composer', 'game', 'danish', 'ccm', 'italy', '60s',
  'madchester', 'Flamenco', 'bolivia', '80s', 'spain', 'venezuela', 'All',
  'valencia', 'british', 'usa', 'jamaica', 'american', 'United States', 'frozen',
  'taylor seift', 'nigeria', 'lilly goodman', 'swedish', 'Mamma mia',
  'Charlie Hodson-Prior', 'uruguay', 'MDB', 'nu disco', 'killer queen', 'french',
  'lesbian', 'shoegaze', 'puerto rico', 'queer', 'in love- Jeff and Beanie',
  'spotify', 'musical theatre', 'switzerland', 'england', 'australia', 'daycore',
  'maldives', 'greek', 'chillwave', 'islandic', 'oldies', 'wood and stick',
  'deathcore', 'chanson francaise', 'nicaragua', 'german', 'español',
  'montevideo', 'peru', 'shit', 'United Kingdom', 'lithuanian', 'us', '8 bit',
  'rich parents', 'chetocore', 'New Zealand', '2000', 'cantautor', 'Nacional',
  'genre', 'new york', 'lidarr', 'curacao', 'surf', '70s', 'Buenos Aires',
  'neoperreo', 'discoverunsigned', 'south african', 'chile',
"drill",
"sound",
"MESCIAK DEBESCIAK",
"radio drama",
"remixer",
"taylor swift",
"No pega solo",
"Fat Fuck",
"visual kei",
"calypso",
"jungle",
"Unites States",
"feel good",
"south africa",
"Marco Antonio Solis",
"X factor",
"fifa 2002",
"america",
"cubaton",
"50s",
"norteño",
"hazbin hotel",
"Queen Iduna",
"hamilton",
"cinderella",
"philippines",
"encanto cast",
"duo",
"tini",
"african",
"mod revival",
"te reo maori",
"locoplaya",
"breakbeat",
"palermitano",
"Norteno",
"gay jew",
"samoa",
"mantra",
"jersey club",
"duos",
"los angeles",
"pan",
"Oi",
"teleseries",
"princess tiana",
"Scottish",
"antifa",
"trombone",
"mistagg",
"dreamgirls",
"villarreal",
"MC 3L",
"please let me lick you",
"Indian",
"ireland",
"no one's home",
"catala",
"mashup",
"flaneur",
"irish",
"remanso",
"Smooth Chill Dinner Background Instrumental Songs",
"future bass",
"Gothic Rock",
"singapore",
"south korea",
"to tag",
"mumford and cunts",
"trumpet",
"krautrock",
"Forro",
"wrestling",
"mexican",
"big room",
"Rent",
"Pablito Ruiz",
"bald",
"Panama",
"I love this song",
"to sleep",
"ahava3",
"Raffa",
"quebec",
"la plata",
"ASMR",
"treble",
"Mondiovision",
"minimal",
"turro",
"barcenas",
"Francisco Colmenero",
"argentinos",
"west coast",
"Dominican roots",
"psy trance",
"turkish",
"belgian",
"rage",
"white rapper",
"sexy",
"Tuvalu",
"managua",
"TCB",
"youtube",
"the greatest showman",
"laowai",
"hands up",
"lesotho",
"club",
"Homer el Mero Mero",
"nickelodeon",
"Lebo M.",
"Paulina Rubio",
"screamo",
"subliminal",
"8-bit",
"Les Miserables",
"Alex Hoyer",
"the prince of the sun",
"Cris Morena",
"francophone",
"Star Wars",
"pelado",
"Rave",
"epic",
"mod",
"Ivory Coast",
"villera",
"LITTLE STAR",
"dog",
"Sweden",
"spirit zone",
"across the universe",
"Eurovision",
"Jerk",
"boom bap",
"Tolkien",
"christmas",
"france",
"Bad porno movie",
"good songs",
"Legendary",
"Lion King",
"Radio",
"Machism",
"italia",
"producer",
"Sweeney Todd",
"india",
"chiptune",
"primo",
"full on",
"ESC",
"under 600 plays",
"doo wop",
"chicago",
"norweigan",
"canada",
"Filipino",
"actress",
"dominican republic",
"Hawaiian",
"actor",
"dutch",
"Canadian",
"ahs double feature",
"OPM",
"Dominican",
];

// Artists to skip (assign null directly)
const artistsToSkip = ['Wesley Saf', 'David and the high spirit', 'Marissa Jaret Winokur', 'Spaghetti Western'];

// Special cases
const specialCases = {
  'Parcels': 'indie',
  'Reino infantil': 'children'
};

/**
 * Checks if a tag should be skipped
 * @param {string} tag - The tag to check
 * @param {string} artistName - The artist name to compare
 * @returns {boolean} - True if the tag should be skipped
 */
function shouldSkipTag(tag, artistName) {
  if (!tag || tag.trim() === '') {
    return true;
  }

  const lowerTag = tag.toLowerCase().trim();
  const lowerArtistName = artistName.toLowerCase().trim();

  // Rule 3: Skip if tag is exactly same as artist name (case-insensitive)
  if (lowerTag === lowerArtistName) {
    return true;
  }

  // Rule 2: Skip if tag contains any of the skip keywords
  for (const skipKeyword of tagsToSkip) {
    if (lowerTag.includes(skipKeyword.toLowerCase())) {
      return true;
    }
  }

  return false;
}

/**
 * Determines the genre for an artist based on tags
 * @param {string} artistName - The artist name
 * @param {string} tag1 - First tag
 * @param {string} tag2 - Second tag
 * @param {string} tag3 - Third tag
 * @returns {string} - The assigned genre or null
 */
function determineGenre(artistName, tag1, tag2, tag3) {
  // Rule 1: Check special cases
  if (specialCases.hasOwnProperty(artistName)) {
    return specialCases[artistName];
  }

  // Rule 4: Check if artist should be skipped (assign null)
  if (artistsToSkip.includes(artistName)) {
    return null;
  }

  // Try tags in priority order: tag1 > tag2 > tag3
  const tags = [tag1, tag2, tag3];

  for (const tag of tags) {
    if (!shouldSkipTag(tag, artistName)) {
      return tag.trim();
    }
  }

  // No valid tag found
  return null;
}

/**
 * Parses the CSV file and generates artist_genre.csv
 */
async function parseAndGenerateOutput() {
  const inputFile = path.join(__dirname, 'artist_tags.csv');
  const outputFile = path.join(__dirname, 'artist_genre.csv');

  const results = [];
  let isFirstLine = true;

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

      // Simple CSV parsing (handles basic cases)
      const row = parseCsvLine(line);
      if (row.length >= 1) {
        const artistName = row[0];
        const tag1 = row[1] || '';
        const tag2 = row[2] || '';
        const tag3 = row[3] || '';

        const genre = determineGenre(artistName, tag1, tag2, tag3);
        results.push({
          artistName,
          genre: genre === null ? '' : genre
        });
      }
    });

    rl.on('close', () => {
      // Write output file
      const outputLines = ['artistName,genre'];
      results.forEach(result => {
        // Escape quotes in artist name if needed
        const escapedArtistName = result.artistName.includes(',')
          ? `"${result.artistName}"`
          : result.artistName;
        outputLines.push(`${escapedArtistName},${result.genre || 'NULL'}`);
      });

      fs.writeFileSync(outputFile, outputLines.join('\n'), 'utf8');
      console.log(`✓ Parser completed successfully!`);
      console.log(`✓ Input: ${inputFile}`);
      console.log(`✓ Output: ${outputFile}`);
      console.log(`✓ Total artists processed: ${results.length}`);
      resolve();
    });

    rl.on('error', reject);
  });
}

/**
 * Simple CSV line parser
 * @param {string} line - The CSV line to parse
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
        i++; // Skip next quote
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

// Run the parser
parseAndGenerateOutput().catch(err => {
  console.error('Error:', err);
  process.exit(1);
});
