﻿// Generated by CoffeeScript 1.10.0
(function() {
  var Csv, Main, main;

  String.prototype.startsWith = function(str) {
    return this.slice(0, str.length) === str;
  };

  String.prototype.endsWith = function(suffix) {
    return this.indexOf(suffix, this.length - suffix.length) !== -1;
  };

  String.prototype.trim = function() {
    return this.replace(/^\s+|\s+$/g, '');
  };

  Csv = (function() {
    function Csv() {}

    Csv.save = function(filePath, data) {
      var file, text;
      text = Csv.toText(data);
      file = new File(filePath);
      file.encoding = "UTF-8";
      file.open("w", "TEXT");
      text = this.toText(data);
      file.write(text);
      return file.close();
    };

    Csv.toText = function(data) {
      var element, elementIndex, i, j, len, len1, line, lineIndex, text;
      text = "";
      for (lineIndex = i = 0, len = data.length; i < len; lineIndex = ++i) {
        line = data[lineIndex];
        for (elementIndex = j = 0, len1 = line.length; j < len1; elementIndex = ++j) {
          element = line[elementIndex];
          text += "\"" + (element.replace(/\"/g, "\"\"")) + "\"";
          if (elementIndex !== line.length - 1) {
            text += ",";
          }
        }
        if (lineIndex !== data.length - 1) {
          text += "\r\n";
        }
      }
      return text;
    };

    Csv.load = function(filePath) {
      var file, text;
      file = new File(filePath);
      file.encoding = "UTF-8";
      file.open("r", "TEXT");
      text = "";
      while (!file.eof) {
        text += file.readln();
        text += "\n";
      }
      file.close();
      return this.fromText(text);
    };

    Csv.fromText = function(text) {
      var body, element, elements, i, j, len, len1, line, lineArray, ref, tmp;
      body = [];
      line = "";
      tmp = "";
      ref = text.split('\n');
      for (i = 0, len = ref.length; i < len; i++) {
        tmp = ref[i];
        lineArray = [];
        tmp = tmp.replace(/\"\"\",/g, "<double quote>\",");
        tmp = tmp.replace(/,\"\"\"/g, ",\"<double quote>");
        tmp = tmp.replace(/\"\"/g, "<double quote>");
        if (line !== "") {
          line += "\n";
        }
        line += tmp;
        if (!line.endsWith(",")) {
          continue;
        }
        tmp = "";
        if (line.replace(/ /, "") === "") {
          continue;
        }
        elements = line.match(/"[^"]*"|[^,]+/g);
        if (elements) {
          for (j = 0, len1 = elements.length; j < len1; j++) {
            element = elements[j];
            if (element.startsWith("\"") && element.endsWith("\"")) {
              element = element.slice(1, element.length - 1).replace(/\"\"/g, "\"");
            }
            lineArray.push(element.replace(/<double quote>/g, "\""));
          }
        }
        body.push(lineArray);
        line = "";
      }
      return body;
    };

    return Csv;

  })();

  Main = (function() {
    function Main() {}

    Main.prototype.run = function() {
      var data, filePath, root;
      root = app.activeDocument;
      filePath = File.saveDialog("保存先指定(*.csv)");
      if (filePath) {
        data = this["export"](root);
        return Csv.save(filePath, data);
      }
    };

    Main.prototype["export"] = function(root) {
      var dict, i, k, len, ref, result, textFrame, v;
      dict = {};
      ref = root.textFrames;
      for (i = 0, len = ref.length; i < len; i++) {
        textFrame = ref[i];
        if (textFrame.locked) {
          continue;
        }
        if (textFrame.visible) {
          continue;
        }
        if (textFrame.contents.replace(/[\n\r]+/g, ' ').replace(/ /, '') === "") {
          continue;
        }
        dict[textFrame.contents.replace(/[\n\r]+/g, ' ')] = "";
      }
      result = [];
      for (k in dict) {
        v = dict[k];
        result.push([k, ""]);
      }
      return result;
    };

    return Main;

  })();

  main = new Main();

  main.run();

  alert('complete!');

}).call(this);
