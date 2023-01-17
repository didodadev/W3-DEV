<cfsetting showdebugoutput="no">
<cfscript>
	function paintEAN13()
	{		
		if((Len(code) eq 12) and checkCharacter){
			if(isNumeric(code))
			code = code & caller.UPCEANCheck(code);
			else
			code = code;
		}
		if(isNumeric(code))
		{
			if(Len(code) lt 13){
				caller.errors = 'Lütfen 12 veya 13 karakterden oluşan bir sayısal bir metin yollayınız !!';
				return;
			}	
		}
		if(isNumeric(code)){
		htmlCode = htmlCode & "<table cellspacing='0' cellpadding='0' border='0'><tr align='center'><td></td><td colspan='3'>";
		caller.calculateSizes();
		i = 0;
		flag = false;
		caller.paintGuardChar( "bwb", "nnn", 0);
		s1 = setEANCode[(Left(code,1) + 1)];
		i = caller.findChar(setEANLeftA, Mid(trim(code),2,1));
		caller.paintChar("wbwb", setEANLeftA[2][i]);
		for( j = 3; j lt 13; j = j + 1)
		{
			s = Mid(trim(code),j,1);
			i = 0;
			if(j lte 7)
			{
				as = setEANLeftA;
				if(Mid(trim(s1),j - 2,1) eq 'B')
					as = setEANLeftB;
				i = caller.findChar(as, s);
				caller.paintChar("wbwb", as[2][i]);
			} else
			{
				i = caller.findChar(setEANRight, s);
				caller.paintChar("bwbw", setEANRight[2][i]);
			}
			if(j eq 7)
			{
				caller.paintGuardChar("wbwbw", "nnnnn", 0);
			}
		}
		i = caller.findChar(setEANRight, Mid(trim(code),13,1));
		caller.paintChar("bwbw", setEANRight[2][i]);
		caller.paintGuardChar( "bwb", "nnn", 0);
		if(Len(codeText) eq 0)
			codeText = code;			
		htmlCode = htmlCode & "</td></tr><tr><td style='font-size:12px;' align='center'> ";
		i1 = 14;
		j1 = 7;
		if((barType eq 10) and guardBars and (Len(codeText) gte 13))
		{			
			htmlCode = htmlCode & Left(codeText,1) & " " & "</td><td style='font-size:12px;'>";
			htmlCode = htmlCode & "<img src='images/bar_black.gif' width='" & 1 & "' height='" & 15 & "'>" & "<img src='images/bar_white.gif' width='" & 1 & "' height='" & 15 & "'>" & "<img src='images/bar_black.gif' width='" & 1 & "' height='" & 15 & "'>";
			htmlCode = htmlCode & "</td><td style='font-size:12px;'>";
			htmlCode = htmlCode & "<table cellspacing='0' cellpadding='0' width='100%'><tr>";
			htmlCode = htmlCode & "<td style='font-size:12px;' align='center' valign='bottom'>" & Mid(trim(codeText), 2, 6) & "</td>";
			htmlCode = htmlCode & "<td style='font-size:12px;' align='center'>" & "<img src='images/bar_black.gif' width='" & 1 & "' height='" & 15 & "'>" & "<img src='images/bar_white.gif' width='" & 1 & "' height='" & 15 & "'>" & "<img src='images/bar_black.gif' width='" & 1 & "' height='" & 15 & "'></td>";
			htmlCode = htmlCode & "<td style='font-size:12px;' align='center' valign='bottom'>" & Mid(trim(codeText), 8, 6);
			htmlCode = htmlCode & "</td></tr></table></td><td style='font-size:12px;' align='right'>";
			htmlCode = htmlCode & "<img src='images/bar_black.gif' width='" & 1 & "' height='" & 15 & "'>" & "<img src='images/bar_white.gif' width='" & 1 & "' height='" & 15 & "'>" & "<img src='images/bar_black.gif' width='" & 1 & "' height='" & 15 & "'>";
			htmlCode = htmlCode & "</td></tr></table>";
			return;
		}
		}
		else{			
				
		htmlCode = htmlCode & "<table cellspacing='0' cellpadding='0' border='0'><tr align='center'><td></td><td colspan='3'>";
		caller.calculateSizes();
		i = 0;
		flag = false;
		caller.paintGuardChar( "bwb", "nnn", 0);
		
		i = caller.findChar(setEANLeftA, Mid(trim(code),2,1));
		caller.paintChar("wbwb", i);
		for( j = 3; j lt 13; j = j + 1)
		{
			s = Mid(trim(code),j,1);
			i = 0;
			if(j lte 7)
			{
				as = setEANLeftA;
				if(Mid(trim(s),j - 2,1) eq 'B')
					as = setEANLeftB;
				i = caller.findChar(as, s);
				caller.paintChar("wbwb", i);
			} else
			{
				i = caller.findChar(setEANRight, s);
				caller.paintChar("bwbw", i);
			}
			if(j eq 7)
			{
				caller.paintGuardChar("wbwbw", "nnnnn", 0);
			}
		}
		i = caller.findChar(setEANRight, Mid(trim(code),13,1));
		caller.paintChar("bwbw", i);
		caller.paintGuardChar( "bwb", "nnn", 0);
		if(Len(codeText) eq 0)
			codeText = code;			
		htmlCode = htmlCode & "</td></tr><tr><td style='font-size:12px;' align='center'> ";
		i1 = 14;
		j1 = 7;
		if((barType eq 10) and guardBars and (Len(codeText) gte 13))
		{			
			htmlCode = htmlCode & Left(codeText,1) & " " & "</td><td style='font-size:12px;'>";
			htmlCode = htmlCode & "<img src='images/bar_black.gif' width='" & 1 & "' height='" & 15 & "'>" & "<img src='images/bar_white.gif' width='" & 1 & "' height='" & 15 & "'>" & "<img src='images/bar_black.gif' width='" & 1 & "' height='" & 15 & "'>";
			htmlCode = htmlCode & "</td><td style='font-size:12px;'>";
			htmlCode = htmlCode & "<table cellspacing='0' cellpadding='0' width='100%'><tr>";
			htmlCode = htmlCode & "<td style='font-size:12px;' align='center' valign='bottom'>" & Mid(trim(codeText), 2, 6) & "</td>";
			htmlCode = htmlCode & "<td style='font-size:12px;' align='center'>" & "<img src='images/bar_black.gif' width='" & 1 & "' height='" & 15 & "'>" & "<img src='images/bar_white.gif' width='" & 1 & "' height='" & 15 & "'>" & "<img src='images/bar_black.gif' width='" & 1 & "' height='" & 15 & "'></td>";
			htmlCode = htmlCode & "<td style='font-size:12px;' align='center' valign='bottom'>" & Mid(trim(codeText), 8, 6);
			htmlCode = htmlCode & "</td></tr></table></td><td style='font-size:12px;' align='right'>";
			htmlCode = htmlCode & "<img src='images/bar_black.gif' width='" & 1 & "' height='" & 15 & "'>" & "<img src='images/bar_white.gif' width='" & 1 & "' height='" & 15 & "'>" & "<img src='images/bar_black.gif' width='" & 1 & "' height='" & 15 & "'>";
			htmlCode = htmlCode & "</td></tr></table>";
			return;
		}
		}
		htmlCode = htmlCode & "</td></tr></table>";	
	}
	
	function paintEAN8()
	{
		if((Len(code) eq 7) and checkCharacter){
			if(isNumeric(code))
			code = code & caller.UPCEANCheck(code);
			else
			code = code;
		}
		if(isNumeric(code)){
			if(Len(code) lt 8){
			caller.errors = 'Lütfen 7 veya 8 rakamdan oluşan barkod yollayınız(2) : #code#<br/>';
			return;}	
		}
		if(isNumeric(code)){
		htmlCode = htmlCode & "<table cellspacing='0' cellpadding='0' border='0'><tr align='center'><td colspan='3'>";
		caller.calculateSizes();
		flag = false;
		caller.paintGuardChar("bwb", "nnn", 0);
		for(k = 1; k lte 8; k = k + 1)
		{
			s = Mid(trim(code), k, 1);
			byte0 = -1;
			if(k lte 4)
			{
				i = caller.findChar(setEANLeftA, s);
				caller.paintChar("wbwb", setEANLeftA[2][i]);
			} else
			{
				j = caller.findChar(setEANRight, s);
				caller.paintChar( "bwbw", setEANRight[2][j]);
			}
			if(k eq 4)
			{
				caller.paintGuardChar("wbwbw", "nnnnn", 0);
			}
		}
		caller.paintGuardChar("bwb", "nnn", 0);
		if(Len(codeText) eq 0)
			codeText = code;			
		htmlCode = htmlCode & "</td></tr><tr><td style='font-size:12px;'> ";			
		if((barType eq 11) and guardBars and (Len(codeText) gte 8))
		{
			htmlCode = htmlCode & "<img src='images/bar_black.gif' width='" & 1 & "' height='" & 15 & "'>" & "<img src='images/bar_white.gif' width='" & 1 & "' height='" & 15 & "'>" & "<img src='images/bar_black.gif' width='" & 1 & "' height='" & 15 & "'>";
			htmlCode = htmlCode & "</td><td style='font-size:12px;'>";
			htmlCode = htmlCode & "<table cellspacing='0' cellpadding='0' width='100%'><tr>";
			htmlCode = htmlCode & "<td style='font-size:12px;' align='center' valign='bottom'>" & Mid(trim(codeText), 1, 4) & "</td>";
			htmlCode = htmlCode & "<td style='font-size:12px;' align='center'>" & "<img src='images/bar_black.gif' width='" & 1 & "' height='" & 15 & "'>" & "<img src='images/bar_white.gif' width='" & 1 & "' height='" & 15 & "'>" & "<img src='images/bar_black.gif' width='" & 1 & "' height='" & 15 & "'></td>";
			htmlCode = htmlCode & "<td style='font-size:12px;' align='center' valign='bottom'>" & Mid(trim(codeText), 5, 4);
			htmlCode = htmlCode & "</td></tr></table></td><td style='font-size:12px;' align='right'>";
			htmlCode = htmlCode & "<img src='images/bar_black.gif' width='" & 1 & "' height='" & 15 & "'>" & "<img src='images/bar_white.gif' width='" & 1 & "' height='" & 15 & "'>" & "<img src='images/bar_black.gif' width='" & 1 & "' height='" & 15 & "'>";
			htmlCode = htmlCode & "</td></tr></table>";
			return;
		}
		}
		else{	
		
		htmlCode = htmlCode & "<table cellspacing='0' cellpadding='0' border='0'><tr align='center'><td colspan='3'>";
		caller.calculateSizes();
		flag = false;
		caller.paintGuardChar("bwb", "nnn", 0);
		for(k = 1; k lte 8; k = k + 1)
		{
			s = Mid(trim(code), k, 1);
			byte0 = -1;
			if(k lte 4)
			{
				i = caller.findChar(setEANLeftA, s);
				caller.paintChar("wbwb", i);
			} else
			{
				j = caller.findChar(setEANRight, s);
				caller.paintChar( "bwbw", j);
			}
			if(k eq 4)
			{
				caller.paintGuardChar("wbwbw", "nnnnn", 0);
			}
		}
		caller.paintGuardChar("bwb", "nnn", 0);
		if(Len(codeText) eq 0)
			codeText = code;			
		htmlCode = htmlCode & "</td></tr><tr><td style='font-size:12px;'> ";			
		if((barType eq 11) and guardBars and (Len(codeText) gte 8))
		{
			htmlCode = htmlCode & "<img src='images/bar_black.gif' width='" & 1 & "' height='" & 15 & "'>" & "<img src='images/bar_white.gif' width='" & 1 & "' height='" & 15 & "'>" & "<img src='images/bar_black.gif' width='" & 1 & "' height='" & 15 & "'>";
			htmlCode = htmlCode & "</td><td style='font-size:12px;'>";
			htmlCode = htmlCode & "<table cellspacing='0' cellpadding='0' width='100%'><tr>";
			htmlCode = htmlCode & "<td style='font-size:12px;' align='center' valign='bottom'>" & Mid(trim(codeText), 1, 4) & "</td>";
			htmlCode = htmlCode & "<td style='font-size:12px;' align='center'>" & "<img src='images/bar_black.gif' width='" & 1 & "' height='" & 15 & "'>" & "<img src='images/bar_white.gif' width='" & 1 & "' height='" & 15 & "'>" & "<img src='images/bar_black.gif' width='" & 1 & "' height='" & 15 & "'></td>";
			htmlCode = htmlCode & "<td style='font-size:12px;' align='center' valign='bottom'>" & Mid(trim(codeText), 5, 4);
			htmlCode = htmlCode & "</td></tr></table></td><td style='font-size:12px;' align='right'>";
			htmlCode = htmlCode & "<img src='images/bar_black.gif' width='" & 1 & "' height='" & 15 & "'>" & "<img src='images/bar_white.gif' width='" & 1 & "' height='" & 15 & "'>" & "<img src='images/bar_black.gif' width='" & 1 & "' height='" & 15 & "'>";
			htmlCode = htmlCode & "</td></tr></table>";
			return;
		}	
		}
		htmlCode = htmlCode & "</td></tr></table>";
	}
	
	function UPCEANCheck(s)
	{
		flag = true;
		i = 0;
		j = 0;
		k = 0;
		for( l = Len(s); l gte 1; l = l - 1)
		{
			if(flag)
				i = i + Mid(trim(s),l,1);
			else
				j = j + Mid(s,l,1);
			flag = not flag;
		}

		j = i * 3 + j;
		k = j mod 10;

		if(k neq 0)
			k = 10 - k;
		if(ext_code lt 0)
			ext_code = k;
		return k;
	}
	
	function findChar(as, s)
	{
		for(f = 1; f lte ArrayLen(as[1]); f = f + 1){
			if(s eq as[1][f])
				return f;
		}
		return 0;
	}
	
	function paintChar(s, s1)
	{
		caller.paintChar2(s, s1, 0);
	}

	function paintChar2(s, s1,  b)
	{
		for( a = 1; a lte Len(s); a = a + 1){
			c = Mid(trim(s),a,1);
			c1 = Mid(trim(s1),a,1);
			if(c1 eq 'n')
				caller.addBar(narrowBarPixels, c eq 'b', b);
			if(c1 eq 'w')
				caller.addBar(widthBarPixels, c eq 'b', b);
			if(c1 eq '1')
				caller.addBar(narrowBarPixels, c eq 'b', b);
			if(c1 eq '2')
				caller.addBar(narrowBarPixels * 2, c eq 'b', b);
			if(c1 eq '3')
				caller.addBar(narrowBarPixels * 3, c eq 'b', b);
			if(c1 eq '4')
				caller.addBar(narrowBarPixels * 4, c eq 'b', b);	
		}
	}
	
	function paintGuardChar(s, s1,  i)
	{
		caller.paintChar2( s, s1, i);
	}
	
	function addBar(i, flag, j)
	{
		if(flag)
			htmlCode = htmlCode & "<img src='images/bar_black.gif' width='" & i & "' height='" & ((barHeightPixels + extraHeight) - j) & "'>";
		else
			htmlCode = htmlCode & "<img src='images/bar_white.gif' width='" & i & "' height='" & ((barHeightPixels + extraHeight) - j) & "'>";
		sideGuardBar = sideGuardBar + i;
	}
	
	function calculateSizes()
	{
		i = Len(code);
		narrowBarCM = X;
		widthBarCM = X * N;		
		if(barType eq 10)
			L = (i * 7) * X + 11 * X;
		if(barType eq 11)
			L = (i * 7) * X + 11 * X;			
		if(barHeightCM eq 0.0)
		{
			barHeightCM = L * H;
			if(barHeightCM lt 0.625)
				barHeightCM = 0.625;
		}		
		if(barHeightCM neq 0.0)
			barHeightPixels = barHeightCM * resolution;
		if(narrowBarCM neq 0.0)
			narrowBarPixels = narrowBarCM * resolution;
		if(widthBarCM neq 0.0)
			widthBarPixels = narrowBarPixels * N;
		if(narrowBarPixels lte 0)
			narrowBarPixels = 1;
		if(widthBarPixels lte 1)
			widthBarPixels = narrowBarPixels * N;
	}
	
	function paintBasis(){
		if(barType eq 10)
			caller.paintEAN13();
		else if(barType eq 11)
			caller.paintEAN8();
		else if(barType eq 16)
			caller.paintPLANET();	
	}

/* 20050617 Ellemeyin pls..workcube terazi barkod check ozellikle NCR ve terazili kasalar 7 hane barkodu alamadigi icin sagina 00000 yazilip check digit yapiyoruz*/
	function WRK_UPCEANCheck(s)
	{
		flag = true;
		iii = 0;
		jjj = 0;
		kkk = 0;
		for( lll = Len(s); lll gte 1; lll = lll - 1)
		{
			if(flag)
				iii = iii + Mid(trim(s),lll,1);
			else
				jjj = jjj + Mid(s,lll,1);
			flag = not flag;
		}

		jjj = iii * 3 + jjj;
		kkk = jjj mod 10;

		if(kkk neq 0)
			kkk = 10 - kkk;
		if(ext_code lt 0)
			ext_code = kkk;
		return kkk;
	}
</cfscript>
