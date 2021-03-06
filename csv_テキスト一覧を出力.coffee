String.prototype.startsWith = (str) ->
  return this.slice(0, str.length) == str

String.prototype.endsWith = (suffix) ->
  return this.indexOf(suffix, this.length - suffix.length) != -1

String.prototype.trim = ->
  return this.replace(/^\s+|\s+$/g,'')

class Csv
  @save: (filePath, data) ->
    text = Csv.toText(data)
    file = new File(filePath)
    file.encoding = "UTF-8"
    file.open("w", "TEXT")
    text = @toText(data)
    file.write(text)
    file.close()

  @toText: (data) ->
    text = ""
    for line, lineIndex in data
      for element, elementIndex in line
        text += "\"#{element.replace(/\"/g, "\"\"")}\""
        text += "," if elementIndex != line.length - 1
      text += "\r\n" if lineIndex != data.length - 1
    text

  @load: (filePath) ->
    file = new File(filePath)
    file.encoding = "UTF-8"
    file.open("r", "TEXT")
    text = ""
    while(!file.eof)
      text += file.readln()
      text += "\n"
    file.close()
    @fromText(text)

  @fromText: (text) ->
    body = []
    line = ""
    tmp = ""
    for tmp in text.split('\n')
      lineArray = []
      tmp = tmp.replace(/\"\"\",/g, "<double quote>\",")
      tmp = tmp.replace(/,\"\"\"/g, ",\"<double quote>")
      tmp = tmp.replace(/\"\"/g, "<double quote>")
      line += "\n" if line != ""
      line += tmp
      continue unless line.endsWith(",")
      tmp = ""
      continue if line.replace(/ /, "") == ""
      elements = line.match(/"[^"]*"|[^,]+/g)
      if elements
        for element in elements
          if element.startsWith("\"") && element.endsWith("\"")
            element = element.slice(1, element.length - 1).replace(/\"\"/g, "\"")
          lineArray.push(element.replace(/<double quote>/g, "\""))
      body.push(lineArray)
      line = ""
    body

class Main
  run: ->
    root = app.activeDocument
    filePath = File.saveDialog("保存先指定(*.csv)")
    if filePath
      data = @export(root)
      Csv.save(filePath, data)

  export: (root) ->
    dict = {}
    for textFrame in root.textFrames
      continue if textFrame.locked
      continue if textFrame.visible
      continue if textFrame.contents.replace(/[\n\r]+/g, ' ').replace(/ /, '') == ""
      dict[textFrame.contents.replace(/[\n\r]+/g, ' ')] = ""
    result = []
    for k, v of dict
      result.push([k, ""])
    result

main = new Main()
main.run()
alert('complete!')
