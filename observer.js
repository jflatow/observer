#!/usr/bin/env node

const path = require('path')
const minimist = require('minimist')
const puppeteer = require('puppeteer-core')

function guessRemotePort(opts) {
  return 9222;
}

function guessChromeExecutable(opts) {
  return `/Applications/Google Chrome Canary.app/Contents/MacOS/Google Chrome Canary`
}

function guessNotebookUrls(opts, urls) {
  if (urls.length > 0)
    return urls;
  return [`https://api.observablehq.com/@jflatow/headless-observable.js?key=7d7a86c7b4aefbef`]
}

function pageLoaders(notebookUrls) {
  return notebookUrls.map(u => `file:///${path.resolve(__dirname, 'notebook.html')}#${u}`)
}

async function main(opts = {}) {
  const {
    _: urls,
    headless,
    remotePort = guessRemotePort(opts),
    executablePath = guessChromeExecutable(opts),
    notebookUrls = guessNotebookUrls(opts, urls),
  } = opts;
  const loaders = pageLoaders(notebookUrls)
  const browser = await puppeteer.launch({
    headless,
    executablePath,
    args: [`--remote-debugging-port=${remotePort}`, ...loaders]
  })
}

if (require.main == module)
  main(minimist(process.argv.slice(2), {
    alias: {
      'p': 'executablePath',
      'P': 'remotePort'
    },
    string: [
      'remotePort',
      'executablePath'
    ],
    boolean: ['headless'],
    default: {
      headless: true
    }
  }))
