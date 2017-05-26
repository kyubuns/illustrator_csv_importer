KEY = "Key"
VALUE = "Value"

class Importer
  run: ->
    root = app.activeDocument
    dict = @readCSV()
    @replaceText(dict, root)

  readCSV: ->
    file = File.openDialog("Select a file", "*")
    file.open('r')
    dict = {}

    # header
    keyIndex = 0
    valueIndex = 0
    elements = file.readln().split(',')
    for e, index in elements
      if e == KEY
        keyIndex = index
      if e == VALUE
        valueIndex = index

    # body
    while(!file.eof)
      elements = file.readln().split(',')
      key = elements[keyIndex]
      value = elements[valueIndex]
      continue if key == ""

      if dict[key]
        continue if value == ""
        dict[key] += "\n"
        dict[key] += value
      else
        dict[key] = value

    file.close()
    dict

  replaceText: (dict, root) ->
    for textFrame in root.textFrames
      if dict[textFrame.name]
        textFrame.contents = dict[textFrame.name]

importer = new Importer()
importer.run()
alert('complete!')
