<cfcomponent extends="CFIDE.websocket.ChannelListener" output="yes" hint="webSocket">
	<cfscript>
        this.application = {};
        function afterUnsubscribe( requestInfo ){
            this.application = new Application();
            if (!structKeyExists( this.application, "onWSRequestStart" )){
                return;
            }
            this.application.onWSRequestStart(
                "unsubscribe",
                requestInfo.channelName,
                this.normalizeConnection( requestInfo.connectionInfo )
            );
            return;
        }
        function allowPublish( requestInfo ){
            this.application = new Application();
            if (!structKeyExists( this.application, "onWSRequestStart" )){
                return( true );
            }
            var result = this.application.onWSRequestStart(
                "publish",
                requestInfo.channelName,
                this.normalizeConnection( requestInfo.connectionInfo )
            );
            if (
                isNull( result ) ||
                !isBoolean( result ) ||
                result
                ){
                return( true );
            }
            return( false );
        }
        function allowSubscribe( requestInfo ){
            this.application = new Application();
            if (!structKeyExists( this.application, "onWSRequestStart" )){
                return( true );
            }
            var result = this.application.onWSRequestStart(
                "subscribe",
                requestInfo.channelName,
                this.normalizeConnection( requestInfo.connectionInfo )
            );
            if (
                isNull( result ) ||
                !isBoolean( result ) ||
                result
                ){
                return( true );
            }
            return( false );
        }
        function beforePublish( message, requestInfo ){
            if (!structKeyExists( this.application, "onWSRequest" )){
                return( message );
            }
            var result = this.application.onWSRequest(
                requestInfo.channelName,
                this.normalizeConnection( requestInfo.connectionInfo ),
                message
            );
            return( result );
        }
        function beforeSendMessage( message, requestInfo ){
            if (!structKeyExists( this.application, "onWSResponse" )){
                return( message );
            }
            var result = this.application.onWSResponse(
                requestInfo.channelName,
                this.normalizeConnection( requestInfo.connectionInfo ),
                message
            );
            return( result );
        }
        function canSendMessage( message, subscriberInfo, publisherInfo ){
            if (!structKeyExists( this.application, "onWSResponseStart" )){
                return( true );
            }
            var result = this.application.onWSResponseStart(
                subscriberInfo.channelName,
                this.normalizeConnection( subscriberInfo.connectionInfo ),
                this.normalizeConnection( publisherInfo.connectionInfo ),
                message
            );
            if (
                isNull( result ) ||
                !isBoolean( result ) ||
                result
                ){
                return( true );
            }
            return( false );
            
        }	
        function normalizeConnection( connection ){
            if (isNull( connection.clientid )){
                connection[ "authenticated" ] = "NO";
                connection[ "clientid" ] = 0;
                connection[ "connectiontime" ] = now();
            }
            return( connection );
        }
        function logData( data ){
            var logFilePath = (
                getDirectoryFromPath( getCurrentTemplatePath() ) & 
                "log.txt"
            );
            writeDump( var=data, output=logFilePath );
        }
    </cfscript>
</cfcomponent>
