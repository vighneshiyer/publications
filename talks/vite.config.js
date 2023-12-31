import { resolve, extname } from 'path'
import { readdirSync } from 'fs'
import { defineConfig } from 'vite'
import { run } from 'vite-plugin-run'

const currentDirectory = process.cwd();

function findHTMLFiles(directory) {
  const files = readdirSync(directory);
  return files.filter(file => extname(file) === '.html');
}

const htmlFiles = findHTMLFiles(currentDirectory);

const input = {};
htmlFiles.forEach(filename => {
  input[filename.replace('.html', '')] = resolve(__dirname, filename);
});

export default defineConfig({
  build: {
    rollupOptions: {
      input: input
    },
  },
  plugins: [
    run([
      {
        name: 'Rebuild html files',
        run: ['make', 'all'],
        pattern: ['talks/**/*.jinja2', 'base/base.jinja2']
      }
    ])
  ]
})
