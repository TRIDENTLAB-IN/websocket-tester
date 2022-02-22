const { app, BrowserWindow } = require('electron')

function createWindow () {
  // Create the browser window.
  const win = new BrowserWindow({

    webPreferences: {
      nodeIntegration: true
    },
    icon: __dirname + '/assets/image/logo.png'
  })


  win.loadFile('index.html')
  //win.webContents.openDevTools()
  win.setTitle("Websocket Tester")
  win.setMenu(null);
  win.maximize();
}

app.on('ready', function () {
  createWindow()
});


// Quit when all windows are closed.
app.on('window-all-closed', () => {
  // On macOS it is common for applications and their menu bar
  // to stay active until the user quits explicitly with Cmd + Q
  if (process.platform !== 'darwin') {
    app.quit()
  }
})

app.on('activate', () => {
  // On macOS it's common to re-create a window in the app when the
  // dock icon is clicked and there are no other windows open.
  if (BrowserWindow.getAllWindows().length === 0) {
    createWindow()
  }
})
