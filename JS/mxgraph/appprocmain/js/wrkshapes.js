(function name() {
    
    function MainProcessShape() {
        mxShape.call(this);
    };
    mxUtils.extend(MainProcessShape, mxShape);

    MainProcessShape.prototype.Title = "Process";

    MainProcessShape.prototype.paintVertexShape = function(c, x, y, w, h) {

        c.translate(x, y);
		
		c.begin();
		c.moveTo(0, 0);
		c.lineTo(w, 0);
		c.moveTo(0, 0);
        c.lineTo(0, h);
        c.moveTo(0, h);
        c.lineTo(w, h);
        c.moveTo(w, 0);
        c.lineTo(w, h);

        c.stroke();

        c.rect(0, 0, w, 20);
        c.setFillAlpha(1);
        c.setFillColor('#66FF66');

        c.fillAndStroke();

        c.text(10, 10, w, 10, "Process", "left", "middle", true);

        c.close();
		c.end();
        
    };
    
    mxCellRenderer.registerShape("mainprocess", MainProcessShape);

    function ProcessShape() {
        mxShape.call(this);
    };
    mxUtils.extend(ProcessShape, mxShape);

    ProcessShape.prototype.paintVertexShape = function(c, x, y, w, h) {

        c.translate(x, y);
		
        c.begin();

        c.moveTo(0, 0);
		c.lineTo(w, 0);
		c.moveTo(0, 0);
        c.lineTo(0, h);
        c.moveTo(0, h);
        c.lineTo(w, h);
        c.moveTo(w, 0);
        c.lineTo(w, h);

        c.stroke();

        c.rect(0, 0, w, 20);
        c.setFillAlpha(1);
        c.setFillColor('#ffca60');

        c.fillAndStroke();
        
        c.text(10, 10, w, 10, "Process", "left", "middle", true);

        c.close();
		c.end();
        
    };

    mxCellRenderer.registerShape("process", ProcessShape);


})();
