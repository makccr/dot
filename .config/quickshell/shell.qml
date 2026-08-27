import Quickshell // for PanelWindow
import Quickshell.lo
import QtQuick // for Text

PanelWindow {
  anchors {
    top: true
    left: true
    right: true
  }

  implicitHeight: 35

  
  Text {
    // give the text an ID we can refer to elsewhere in the file
    id: clock

    anchors.centerIn: parent

    // create a process management object
    Process {
      // the command it will run, every argument is its own string
      command: ["date"]

      // run the command immediately
      running: true

      // process the stdout stream using a StdioCollector
      // Use StdioCollector to retrieve the text the process sends
      // to stdout.
      stdout: StdioCollector {
        // Listen for the streamFinished signal, which is sent
        // when the process closes stdout or exits.
        onStreamFinished: clock.text = this.text // `this` can be omitted
      }
    }
}
}
