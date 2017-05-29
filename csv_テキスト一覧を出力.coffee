String.prototype.startsWith = (str) ->
  return this.slice(0, str.length) == str

String.prototype.endsWith = (suffix) ->
  return this.indexOf(suffix, this.length - suffix.length) != -1

class Main
  run: ->
    root = app.activeDocument
    fileName = File.saveDialog("保存先指定(*.tsv)")
    if fileName
      file = new File(fileName)
      file.encoding = "SHIFT-JIS"
      file.open("w", "TEXT")
      @export(root, file)
      file.close()

  export: (root, file) ->
    dict = {}
    for textFrame in root.textFrames
      continue if textFrame.locked
      continue if textFrame.visible
      continue if textFrame.contents.replace(/[\n\r]+/g, ' ').replace(/ /, '') == ""
      dict[textFrame.contents.replace(/[\n\r]+/g, ' ')] = ""
    for k, v of dict
      file.write("#{k}\t\n")

main = new Main()
main.run()
alert('complete!')
