class mx.services.Log
{
    var level, name;
    function Log(logLevel, name)
    {
        level = logLevel == undefined ? (mx.services.Log.BRIEF) : (logLevel);
        this.name = name == undefined ? ("") : (name);
    } // End of the function
    function logInfo(msg, level)
    {
        if (level == undefined)
        {
            level = mx.services.Log.BRIEF;
        } // end if
        if (level <= this.level)
        {
            if (level == mx.services.Log.DEBUG)
            {
                this.onLog(this.getDateString() + " [DEBUG] " + name + ": " + msg);
            }
            else
            {
                this.onLog(this.getDateString() + " [INFO] " + name + ": " + msg);
            } // end if
        } // end else if
    } // End of the function
    function logDebug(msg)
    {
        this.logInfo(msg, mx.services.Log.DEBUG);
    } // End of the function
    function getDateString()
    {
        var _loc1 = new Date();
        return (_loc1.getMonth() + 1 + "/" + _loc1.getDate() + " " + _loc1.getHours() + ":" + _loc1.getMinutes() + ":" + _loc1.getSeconds());
    } // End of the function
    function onLog(message)
    {
        trace (message);
    } // End of the function
    static var NONE = -1;
    static var BRIEF = 0;
    static var VERBOSE = 1;
    static var DEBUG = 2;
} // End of Class
