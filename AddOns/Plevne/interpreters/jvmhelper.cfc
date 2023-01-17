component
	output = false
	hint = "I help inspect the state of the JVM that is running ColdFusion, and the system on which is running."
	{

	/**
	* I initialize the JVM Helper. The JVM Helper is a thin proxy around the underlying
	* Java management objects that expose metrics pertaining to memory, CPU, threads,
	* garbage collection (and a host of other things).
	* 
	* @output false
	*/
	public any function init() {

		// The ManagementFactory provides access to the underlying MXBeans, which expose
		// metrics around the low-level JVM instrumentation.
		// --
		// Read More: https://docs.oracle.com/javase/8/docs/api/java/lang/management/package-summary.html
		variables.javaManagementFactory = createObject( "java", "java.lang.management.ManagementFactory" );

		// The JVM will only have a single instance of the OperatingSystemMXBean, which 
		// exposes the management interface for the operating system on which the Java
		// virtual machine is running.
		variables.operatingSystemMXBean = javaManagementFactory.getOperatingSystemMXBean();

		// The JVM may have several instances of the GabageCollectionMXBean, depending on
		// which Garbage Collection (GC) algorithm is currently in place. If the GC
		// algorithm is changed, the NAME of these beans will also change. These beans
		// expose information about the amount of CPU time that is being used to find and
		// reclaim unused memory space.
		variables.garbageCollectorMXBeans = javaManagementFactory.getGarbageCollectorMXBeans();

		// The JVM will only have a single instance of the ThreadMXBean, which exposes
		// the management interface for the threads running on the JVM.
		variables.threadMXBean = javaManagementFactory.getThreadMXBean();

		// The JVM will only have a single instance of the MemoryMXBean, which exposes
		// the management interface for the memory system of the JVM.
		variables.memoryMxBean = javaManagementFactory.getMemoryMXBean();

		// The garbage collection information reported by the MXBeans consists of running
		// totals (around Time and Counts) since the JVM was started. As such, we have to
		// keep track of when the GC information was last checked such that we can
		// determine the delta-time and then calculate what percentage of that time was
		// taken by GC processing load. Each cache item will contain "timeChecked" and
		// "timeSpent". But, we won't know the cache items ahead of time as the GC
		// algorithm is different in each JVM environment (depending on which algorithm
		// is current in place).
		variables.gcCache = {};

	}

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I return the number of processors available to the JVM.
	* 
	* @output false
	*/
	public numeric function getProcessors() {

		return( operatingSystemMXBean.getAvailableProcessors() );

	}

	/**
	* I return the percentage of CPU time (0..100, inclusive) that was recently consumed
	* by the JVM process.
	* 
	* @output false
	*/
	public numeric function getCpuLoad() {

		// CAUTION: The ".getProcessCpuLoad()" method is documented in Java 7 but no
		// longer appears in the Java 8+ documentation. However, this method continues to
		// work on some JVMs as a hidden set of features. The implementation details here
		// may need to change depending on which JVM you are using.
		var cpuLoad = ( operatingSystemMXBean.getProcessCpuLoad() * 100 );

		// If the CPU values cannot be measured in this JVM, the above method will
		// return a negative value. In such cases, we'll create a local minimum of zero.
		return( minOfZero( cpuLoad ) );

	}


	/**
	* I return the percentage of CPU time (0..100, inclusive) that was recently consumed
	* by the System process (ie, the whole system).
	* 
	* @output false
	*/
	public numeric function getCpuLoadForSystem() {

		// CAUTION: The ".getSystemCpuLoad()" method is documented in Java 7 but no
		// longer appears in the Java 8+ documentation. However, this method continues to
		// work on some JVMs as a hidden set of features. The implementation details here
		// may need to change depending on which JVM you are using.
		var cpuLoad = ( operatingSystemMXBean.getSystemCpuLoad() * 100 );

		// If the CPU values cannot be measured in this system, the above method will
		// return a negative value. In such cases, we'll create a local minimum of zero.
		return( minOfZero( cpuLoad ) );

	}


	/**
	* I return the garbage collection statistics for the JVM. These stats are relative to
	* when this method WAS LAST CALLED. As such, it makes sense to call this method on an
	* ongoing interval in order to observe the "pulse" of the memory management. The keys
	* returned in the resultant object will change depending on which GC algorithms are
	* in place. For example, the results might contain the following keys on one system:
	* 
	* - "PS MarkSweep"
	* - "PS Scavenge"
	* 
	* ... and then the following keys on another system:
	* 
	* - "G1 Young Generation"
	* - "G1 Old Generation"
	* 
	* CAUTION: This method uses an internal lock; and, will throw an error if the lock
	* cannot be obtained.
	* 
	* @output false
	*/
	public struct function getGcStats() {

		// Since the garbage collection stats are based on running totals, we need to
		// synchronize access to our metric cache so that potentially-overlapping calls
		// to this method don't corrupt the cache.
		lock
			name = getGcStatsLockName()
			type = "exclusive"
			timeout = 1
			throwOnTimeout = true
			{

			var results = {};

			for ( var bean in garbageCollectorMXBeans ) {

				var beanName = bean.getObjectName().getKeyProperty( javaCast( "string", "name" ) );

				// Since we don't know which GabageCollectionMXBean instances will be
				// available ahead of time, our cache will be empty the first time this
				// method is invoked.
				if ( ! structKeyExists( gcCache, beanName ) ) {

					gcCache[ beanName ] = {
						timeChecked: 0,
						timeSpent: 0
					};

				}

				// Because we defaulted our cache to use "0", we'll know that this is the
				// first check based on the cached value.
				var previousCheck = gcCache[ beanName ];
				var isFirstCheck = ( previousCheck.timeChecked == 0 );

				// Get the current, running totals for the current GC Bean (ie, the
				// amount of time that was spent performing garbage collection). If the
				// total is unavailable for this system, a -1 will be returned. In such
				// cases, we'll create a local minimum of 0.
				var timeChecked = getTickCount();
				var timeSpent = minOfZero( bean.getCollectionTime() );

				// Compare the current totals to the cached totals.
				var timeCheckedDelta = ( timeChecked - previousCheck.timeChecked );
				var timeSpentDelta = ( timeSpent - previousCheck.timeSpent );

				// Cache the current totals for the next check.
				previousCheck.timeChecked = timeChecked;
				previousCheck.timeSpent = timeSpent;

				// Because the CPU load calculation is based on cached values in the
				// ColdFusion memory space, a refresh of the application without a
				// restart of the JVM will lead to inaccurate numbers. As such, if this
				// is the first check (as far as ColdFusion is concerned), then we have
				// to return zero, deferring to future checks for better accuracy.
				// --
				// NOTE: We're also protecting against a divide-by-zero error if the
				// gc-load is called multiple times within the same millisecond (which
				// appears to be possible based on observed error logs).
				if ( isFirstCheck || ! timeCheckedDelta ) {

					results[ beanName ] = 0;

				// If this is NOT THE FIRST CHECK, the we can calculate how much of the
				// CPU time was consumed by garbage collection (since the last check) by
				// comparing the GC time to the wall-clock time.
				} else {

					results[ beanName ] = ( timeSpentDelta / timeCheckedDelta * 100 );

				}

			} // END: For-loop.

			return( results );

		} // END: Lock.

	}


	/**
	* I return the synchronization lock name for the GC stats access.
	* 
	* @output false
	*/
	public string function getGcStatsLockName() {

		return( "jvmHelper.getGcStats" );

	}


	/**
	* I return the amount of memory allocated for the heap portion of the JVM.
	* 
	* @output false
	*/
	public struct function getMemoryUsageForHeap() {

		var jvmMemoryUsage = memoryMxBean.getHeapMemoryUsage();

		// NOTE: Since the max does not need to be set, it will return -1 if undefined.
		// In such cases, we'll create a local minimum of zero.
		var results = {
			max: minOfZero( jvmMemoryUsage.getMax() ),
			committed: jvmMemoryUsage.getCommitted(),
			used: jvmMemoryUsage.getUsed()
		};

		return( results );

	}


	/**
	* I return the amount of memory allocated for the non-heap portion of the JVM.
	* 
	* @output false
	*/
	public struct function getMemoryUsageForNonHeap() {

		var jvmMemoryUsage = memoryMxBean.getNonHeapMemoryUsage();

		// NOTE: Since the max does not need to be set, it will return -1 if undefined.
		// In such cases, we'll create a local minimum of zero.
		var results = {
			max: minOfZero( jvmMemoryUsage.getMax() ),
			committed: jvmMemoryUsage.getCommitted(),
			used: jvmMemoryUsage.getUsed()
		};

		return( results );

	}


	/**
	* I return a full thread-dump of the current JVM state. This will show what each
	* thread is doing at [roughly] this moment.
	* 
	* @maxStackDepth I determine the maximum number of StackTraceElement items to be retrieved from the stack trace.
	* @output false
	*/
	public string function getThreadDump( numeric maxStackDepth = 30 ) {

		// Each line of the thread dump is going to be appended to this buffer. Then
		// this buffer will be collapsed down into a single string.
		var buffer = [];
		var newline = chr( 10 );
		var tab = chr( 9 );

		// Get the thread meta-data for all current threads.
		// --
		// CAUTION: Since gathering the IDs and gathering the meta-data are two separate
		// actions, there is a chance that some of the threads (corresponding to gathered
		// IDs) will no longer exist by the time the meta-data is gathered. In such
		// cases, the thread meta-data will be undefined in the resulting array.
		var allThreadIDs = threadMXBean.getAllThreadIds();
		var allThreads = threadMXBean.getThreadInfo( allThreadIDs, javaCast( "int", maxStackDepth ) );
		var allThreadsCount = arrayLen( allThreads );

		for ( var i = 1 ; i <= allThreadsCount ; i++ ) {

			// If the thread no longer existed by the time the meta-data was gathered,
			// skip over it.
			if ( ! arrayIsDefined( allThreads, i ) ) {

				continue;

			}

			var threadInfo = allThreads[ i ];

			arrayAppend( buffer, """#threadInfo.getThreadName()#""" );
			arrayAppend( buffer, "#tab#java.lang.Thread.State: #threadInfo.getThreadState().toString()#" );

			for ( var stackTraceElement in threadInfo.getStackTrace() ) {

				arrayAppend( buffer, "#tab##tab#at #stackTraceElement.toString()#" );

			}

			arrayAppend( buffer, "" );

		}

		return( arrayToList( buffer, newline ) );

	}


	/**
	* I return the thread statistics for the JVM.
	* 
	* @output false
	*/
	public struct function getThreadStats() {

		var results = {
			"all": threadMXBean.getThreadCount(),
			"daemon": threadMXBean.getDaemonThreadCount(),
			"blocked": 0,
			"new": 0,
			"runnable": 0,
			"terminated": 0,
			"timed_waiting": 0,
			"waiting": 0
		};

		var allThreads = threadMXBean.getThreadInfo( threadMXBean.getAllThreadIds() );
		var allThreadsCount = arrayLen( allThreads );

		for ( var i = 1 ; i <= allThreadsCount ; i++ ) {

			// If one of the threads dies in between getting the IDs and getting the
			// state, it will come back as NULL. As such, we have to make sure the array
			// is defined at the given offset.
			if ( arrayIsDefined( allThreads, i ) ) {

				switch ( allThreads[ i ].getThreadState().toString() ) {
					case "BLOCKED":
						results.blocked++;
					break;
					case "NEW":
						results.new++;
					break;
					case "RUNNABLE":
						results.runnable++;
					break;
					case "TERMINATED":
						results.terminated++;
					break;
					case "TIMED_WAITING":
						results.timed_waiting++;
					break;
					case "WAITING":
						results.waiting++;
					break;
				}

			}

		}

		return( results );

	}

	// ---
	// PRIVATE METHODS.
	// ---

	/**
	* I return zero if the given value is negative.
	* 
	* @value I am the value being inspected.
	* @output false
	*/
	private numeric function minOfZero( required numeric value ) {

		return( max( value, 0 ) );

	}

}