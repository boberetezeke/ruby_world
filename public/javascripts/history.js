// insert javascript code below

var charArray = new Array(
	' ', '!', '"', '#', '$', '%', '&', "'", '(', ')', '*', '+', ',', '-',
	'.', '/', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ':', ';',
	'<', '=', '>', '?', '@', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I',
	'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W',
	'X', 'Y', 'Z', '[', '\\', ']', '^', '_', '`', 'a', 'b', 'c', 'd', 'e',
	'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's',
	't', 'u', 'v', 'w', 'x', 'y', 'z', '{', '|', '}', '~', '', 'Ç', 'ü',
	'é', 'â', 'ä', 'à', 'å', 'ç', 'ê', 'ë', 'è', 'ï', 'î', 'ì', 'Ä', 'Å',
	'É', 'æ', 'Æ', 'ô', 'ö', 'ò', 'û', 'ù', 'ÿ', 'Ö', 'Ü', 'ø', '£', 'Ø',
	'×', 'ƒ', 'á', 'í', 'ó', 'ú', 'ñ', 'Ñ', 'ª', 'º', '¿', '®', '¬', '½',
	'¼', '¡', '«', '»', '_', '_', '_', '¦', '¦', 'Á', 'Â', 'À', '©', '¦',
	'¦', '+', '+', '¢', '¥', '+', '+', '-', '-', '+', '-', '+', 'ã', 'Ã',
	'+', '+', '-', '-', '¦', '-', '+', '¤', 'ð', 'Ð', 'Ê', 'Ë', 'È', 'i',
	'Í', 'Î', 'Ï', '+', '+', '_', '_', '¦', 'Ì', '_', 'Ó', 'ß', 'Ô', 'Ò',
	'õ', 'Õ', 'µ', 'þ', 'Þ', 'Ú', 'Û', 'Ù', 'ý', 'Ý', '¯', '´', '­', '±',
	'_', '¾', '¶', '§', '÷', '¸', '°', '¨', '·', '¹', '³', '²', '_', ' ');

function History() {
	var history = this
	this.ctrl_down = false

	this.initialize = function(control_id, history_array) {
		$(control_id).observe('keydown', this.keydown_handler)
		$(control_id).observe('keyup', this.keyup_handler)
		this.control_id = control_id
		history_array.push("")
		this.array = history_array
		this.index = history_array.length - 1
		$(control_id).value = ""
	}

	this.byteToChar = function(n) {
		if (n == 10) return "\n";
		if (n == 13) return "\r";
		if(n < 32 || n > 255) return " ";
		return charArray[n-32];
	}

   this.translate_history_string = function(str) {
		var char_str = "";
		var i;
		for(i=0; i < str.length; i+=2)
			char_str += this.byteToChar(parseInt(str.substring(i, i+2), 16));
		return char_str;
   }
	
	this.keydown_handler = function(event) {
	  if (event.keyCode == Event.KEY_UP) {
		 console.log("up key pressed")
	  }
	  else if (event.keyCode == Event.KEY_DOWN) {
		 console.log("down key pressed")
	  }

	  if (event.altKey) {
		 console.log("alt key");
	  }
	  else if (event.ctrlKey) {
		 console.log("ctrl key");
		 history.ctrl_down = true
	  }
	  else if (event.shiftKey) {
		 console.log("shift key");
	  }
	}

	this.keyup_handler = function(event) {
	  if (event.keyCode == Event.KEY_UP) {
		 console.log("up key released")
		 if (history.ctrl_down) {
			console.log("ctrl up key pressed")
			if (history.index > 0) {
				//history.array[history.index] = $(history.control_id).value
				history.index -= 1
				$(history.control_id).value = history.translate_history_string(history.array[history.index])
			}
		 }
	  }
	  else if (event.keyCode == Event.KEY_DOWN) {
		 console.log("down key released")
		 if (history.ctrl_down) {
			console.log("ctrl down key pressed")
			if (history.index < history.array.length - 1) {
				//history.array[history.index] = $(history.control_id).value
				history.index += 1
				$(history.control_id).value = history.translate_history_string(history.array[history.index])
			}
		 }
	  }
	  if (event.altKey) {
		 console.log("alt key released");
	  }
	  else if (event.ctrlKey) {
		 console.log("ctrl key released");
		 history.ctrl_down = false
	  }
	  else if (event.shiftKey) {
		 console.log("shift key released");
	  }
	}

}
