
let Runtime, Inspector;
let notebook, cells;

async function loadNotebook(url) {
  ({Runtime, Inspector} = await import('https://unpkg.com/@observablehq/notebook-runtime?module'));
  ({default: notebook} = await import(url));
  cells = {}
  Runtime.load(notebook, (cell) => {
    if (cell.name) {
      const div = document.createElement('div')
      const name = document.createElement('div')
      const view = document.createElement('div')
      document.body.appendChild(div)
      div.classList.add('cell')
      div.appendChild(name)
      div.appendChild(view)
      name.classList.add('name')
      name.innerText = cell.name;
      view.classList.add('view')

      const inspector = new Inspector(view)
      return {
        pending: () => {
          inspector.pending()
        },

        fulfilled: (value) => {
          cells[cell.name] = value;
          inspector.fulfilled(value)
        },

        rejected: (error) => {
          cells[cell.name] = error;
          inspector.rejected(error)
        }
      }
    }
  })
}

let url = window.location.hash.replace(/^#/, '')
loadNotebook(url)