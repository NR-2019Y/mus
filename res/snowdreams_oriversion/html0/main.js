
function genAudioPiece(Arraudio, ArrTime) {
	var apieces = [];
	var lastAp = { a:[], t:[] };
	var t = 0;
	for(var i = 0, iend = Arraudio.length; i < iend; ++i) {
		t += ArrTime[i];
		lastAp.a.push(Arraudio[i]);
		lastAp.t.push(ArrTime[i]);
		if(t == 32) {
			apieces.push(lastAp);
			lastAp = ({ a:[], t:[] });
			t = 0;
		}
	}
	return apieces;
}

function printPiece(aps, color, INDEX) {
	const tdEleLength = 10;
	const sbegin = `<table border="1">\n`;
	const send = `</table>\n`;
	var sm = `<tr>
<th style = "width:${tdEleLength*4}px" bgcolor="${color}"> </th>
<th style = "width:${tdEleLength*4}px" bgcolor="${color}"> </th>
<th style = "width:${tdEleLength*4}px" bgcolor="${color}"> </th>
<th style = "width:${tdEleLength*4}px" bgcolor="${color}"> </th>
<th style = "width:${tdEleLength*4}px" bgcolor="${color}"> </th>
<th style = "width:${tdEleLength*4}px" bgcolor="${color}"> </th>
<th style = "width:${tdEleLength*4}px" bgcolor="${color}"> </th>
<th style = "width:${tdEleLength*4}px" bgcolor="${color}"> </th>
</tr>\n`;
	var colors = ["#00FFFF", "#FF00FF"];
	var colorCurrPlay = "yellow";
	for(var apidx in aps) {
		var ap = aps[apidx];
		var s = "<tr>\n";
		var tcum = 0;
		for(var i in ap.t) {
			var isCurrPlay = (4*INDEX >= tcum) && (4*(INDEX+1) <= tcum + ap.t[i]);
			var col = isCurrPlay ? colorCurrPlay : colors[ apidx ];
			tcum += ap.t[i];
			s += `<td colspan=${ap.t[i] / 4} align="center" bgcolor="${ col }">${ap.a[i].split('/').reverse().join('</br>')}</td>\n`;
		}
		s += "</tr>\n";
		sm += s;
	}
	return sbegin + sm + send;
}

function main() {
	const apiecesH = genAudioPiece(AH, TH);
	const apiecesL = genAudioPiece(AL, TL);
	const sbegin = `<table border="2">\n`;
	const send   = "</table>\n";
	var oriVecSEachLine = new Array(Math.ceil(apiecesH.length / 2));
	for(var i = 0, iend = oriVecSEachLine.length; i < iend; ++i) {
		oriVecSEachLine[i] = "<tr>\n<td>\n" +
		printPiece([apiecesH[i*2    ], apiecesL[i*2    ]], "red" , 8) + "</td>\n<td>\n" +
		printPiece([apiecesH[i*2 + 1], apiecesL[i*2 + 1]], "blue", 8) + "</td>\n</tr>\n";
	}
	var idx = 0;
	
	const basicNoteTime = 450;
	const startTime = new Date().getTime();
	
	function updateMus() {
		var currentVecSEachLine = new Array().concat(oriVecSEachLine);
		var ColIndex  = idx % 16;
		var LineIndex = Math.floor( idx / 16 );
		if(ColIndex < 8) {
			currentVecSEachLine[ LineIndex ] = "<tr>\n<td>\n" + 
			printPiece([apiecesH[LineIndex*2    ], apiecesL[LineIndex*2    ]], "red" , ColIndex) + "</td>\n<td>\n" +
			printPiece([apiecesH[LineIndex*2 + 1], apiecesL[LineIndex*2 + 1]], "blue", 8       ) + "</td>\n</tr>\n";
		} else {
			currentVecSEachLine[ LineIndex ] = "<tr>\n<td>\n" + 
			printPiece([apiecesH[LineIndex*2    ], apiecesL[LineIndex*2    ]], "red" , 8       ) + "</td>\n<td>\n" +
			printPiece([apiecesH[LineIndex*2 + 1], apiecesL[LineIndex*2 + 1]], "blue", ColIndex - 8) + "</td>\n</tr>\n";
		}
		document.getElementById("A1").innerHTML = sbegin + currentVecSEachLine.slice(LineIndex, LineIndex+3).join("") + send;
		++idx;
		if(idx < apiecesH.length * 8) {
			setTimeout(updateMus, basicNoteTime * idx - ( new Date().getTime() - startTime ) );
		}
	}
	var mus = document.getElementById("MUSIC");
	mus.play();
	updateMus();
}

