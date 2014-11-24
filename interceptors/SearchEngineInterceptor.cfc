component extends="coldbox.system.Interceptor" output=false {

	property name="elasticSearchEngine" inject="provider:elasticSearchEngine";
	property name="elasticSearchConfig" inject="provider:elasticSearchPresideObjectConfigurationReader";

// PUBLIC
	public void function configure() output=false {}

	public void function preElasticSearchIndexDoc( event, interceptData ) output=false {
		_getSearchEngine().filterPageTypeRecords(
			  objectName = interceptData.objectName ?: ""
			, records    = interceptData.doc        ?: []
		);
	}
	public void function preElasticSearchIndexDocs( event, interceptData ) output=false {
		_getSearchEngine().filterPageTypeRecords(
			  objectName = interceptData.objectName ?: ""
			, records    = interceptData.docs       ?: []
		);
	}

	public void function postInsertObjectData( event, interceptData ) output=false {
		var id = Len( Trim( interceptData.newId ?: "" ) ) ? interceptData.newId : ( interceptData.data.id ?: "" );

		if ( Len( Trim( id ) ) ) {
			_getSearchEngine().indexRecord(
				  objectName = interceptData.objectName ?: ""
				, id         = id
			);
		}
	}

	public void function postUpdateObjectData( event, interceptData ) output=false {
		var id = interceptData.id ?: "";

		if ( Len( Trim( id ) ) ) {
			_getSearchEngine().indexRecord(
				  objectName = interceptData.objectName ?: ""
				, id         = id
			);
		}
	}

	public void function preDeleteObjectData( event, interceptData ) output=false {
		_getSearchEngine().deleteRecord(
			  objectName = interceptData.objectName ?: ""
			, id         = interceptData.id ?: ""
		);
	}


// PRIVATE
	private boolean function _isSearchEnabled( required string objectName ) output=false {
		return Len( Trim( arguments.objectName ) ) && _getElasticSearchConfig().isObjectSearchEnabled( arguments.objectName );
	}
	private any function _getSearchEngine() output=false {
		return elasticSearchEngine.get();
	}
	private any function _getElasticSearchConfig() output=false {
		return elasticSearchConfig.get();
	}
}