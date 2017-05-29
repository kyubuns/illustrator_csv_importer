String.prototype.startsWith = (str) ->
  return this.slice(0, str.length) == str

String.prototype.endsWith = (suffix) ->
  return this.indexOf(suffix, this.length - suffix.length) != -1

class Main
  run: ->
    root = app.activeDocument
    fileName = File.openDialog("tsv選択", "*.tsv")
    if fileName
      file = new File(fileName)
      dict = @createDict(file)
      @setLayerName(root, dict)

  createDict: (file) ->
    file.encoding = "SHIFT-JIS"
    file.open("r", "TEXT")
    dict = {}
    while(!file.eof)
      elements = file.readln().split('\t')
      dict[elements[0]] = elements[1]
    dict

  setLayerName: (root, dict) ->
    for textFrame in root.textFrames
      continue if textFrame.locked
      text = textFrame.contents.replace(/[\n\r]+/g, ' ')
      if dict[text]
        textFrame.name = dict[text]

main = new Main()
main.run()
alert('complete!')
