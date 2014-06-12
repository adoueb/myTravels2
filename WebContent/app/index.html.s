<!doctype html>
<html lang="en" ng-app="travelApp">
<head>
<meta charset="utf-8">
<title>My Travels</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="">
<meta name="author" content="">
<!-- In production use:
  <link href="dist/css/bootstrap.min.css" rel="stylesheet">
  -->
<link href="dist/css/bootstrap.css" rel="stylesheet">
<link href="css/app.css" rel="stylesheet">
<!-- CSS to style the file input field as button and adjust the Bootstrap progress bars -->
<link rel="stylesheet" href="css/jquery.fileupload.css">
<link rel="stylesheet" href="css/jquery.fileupload-ui.css">
</head>
<!-- TODO -->
<!-- Internationalization -->
<body  ng-controller="TravelListCtrl" ng-cloak>
  	<!-- ========================================================================================== -->
 	<!-- Libraries: AngularJS, jQuery, Bootstrap, underscore, Google Maps API, angular-google-maps  -->
 	<!-- ========================================================================================== -->
 	<!-- Placed at the top of the landing page with ng-cloak because the page is mainly dynamic -->
 	<!-- Wrong: Placed at the end of the document so the pages load faster -->
 	
	<!-- In production use: -->
    <!-- script src="//ajax.googleapis.com/ajax/libs/angularjs/1.0.7/angular.min.js"></script -->
	<script src="js/angular-file-upload-shim.js"></script>
	<script src="lib/angular/angular.js"></script>
	<script src="lib/angular/angular-route.js"></script>
	<script src="lib/angular/angular-resource.js"></script>
	<script src="js/angular-file-upload.js"></script>
	<script src="js/app.js"></script>
	<script src="js/services.js"></script>
	<script src="js/controllers.js"></script>
	<script src="js/filters.js"></script>
	<script src="js/directives.js"></script>
    <!-- script src="http://code.jquery.com/jquery-latest.js"></script -->
	<script src="dist/js/jquery-latest.js"></script>
	<!-- In production use:
    <script src="dist/js/bootstrap.min.js"></script>
    -->
    <script src="dist/js/bootstrap.js"></script>
    <!-- script src="http://cdn.jsdelivr.net/restangular/latest/restangular.js"></script -->
    <!--  script src="dist/js/restangular.js"></script -->
	<!-- script type="text/javascript" src="http://cdn.jsdelivr.net/restangular/latest/restangular.min.js"></script -->
	<!-- script type="text/javascript" src="http://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.4.4/underscore-min.js"></script -->
	<script type="text/javascript" src="dist/js/underscore-min.js"></script>
	<script src='//maps.googleapis.com/maps/api/js?sensor=false'></script>
	<script type="text/javascript" src="dist/js/angular-google-maps.js"></script>
	<!--script src="https://raw.github.com/nlaplante/angular-google-maps/master/dist/angular-google-maps.min.js" type="text/javascript"></script-->
	

 	<!-- ========================================================================================== -->
 	<!-- Collapsing Nav Bar                                                                         -->
 	<!-- ========================================================================================== -->
 	<div class="navbar navbar-inverse navbar-static-top">
 		<div class="container">
 			<a href="#" class="navbar-brand"><img src="img/static/Logo.jpg" height="20px"> My Travels</a>
 			
 			<button class="navbar-toggle" data-toggle="collapse" data-target=".navHeaderCollapse">
 				<span class="icon-bar"></span>
 				<span class="icon-bar"></span>
 				<span class="icon-bar"></span>
 			</button>
 			
 			<!-- TODO -->
 			<div class="collapse navbar-collapse navHeaderCollapse">
 				<ul class="nav navbar-nav navbar-right">
 					<li class="active"><a href="#">Home</a></li>
 					<!-- li><a href="#">Blog</a></li>
 					<li class="dropdown">
 						<a href="#" class="dropdown-toggle" data-toggle="dropdown">Social Media <b class="caret"></b></a>
 						<ul class="dropdown-menu">
 						<li><a href="#">Twitter</a></li>
 						<li><a href="#">Facebook</a></li>
 						<li><a href="#">Google+</a></li>
 						<li><a href="#">Instagram</a></li>
 						</ul>
 					</li -->
 					<li class="dropdown">
 						<a href="#" class="dropdown-toggle" data-toggle="dropdown">Itinerary <b class="caret"></b></a>
 						<ul class="dropdown-menu">
 						<li><a href="#">Manage</a></li>
 						</ul>
 					</li>
  					<li class="dropdown">
 						<a href="#" class="dropdown-toggle" data-toggle="dropdown">Photos <b class="caret"></b></a>
 						<ul class="dropdown-menu">
 						<li><a href="#">Manage</a></li>
 						</ul>
 					</li>
 					<li><a href="#">About</a></li>
 					<li><a href="#contact" data-toggle="modal">Contact</a></li>
 				</ul>
 			</div>

 		</div>
 	</div>
 	
  	<!-- ========================================================================================== -->
 	<!-- Alerts                                                                                     -->
 	<!-- ========================================================================================== -->
 	<div ng-repeat="error in MainErrors">
		<div class="alert alert-dismissable" ng-class="{'alert-danger': error.class == 'danger', 'alert-warning': error.class == 'warning', 'alert-info': error.class == 'info', 'alert-success': error.class == 'success'}">
        	<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        	{{error.description}}
		</div>
	</div>
 
  	<!-- ========================================================================================== -->
 	<!-- Articles                                                                                   -->
 	<!-- ========================================================================================== -->
 	<div class="container">
	 	<div class="row">
		  	<!-- ========================================================================================== -->
		 	<!-- Main article                                                                               -->
		 	<!-- ========================================================================================== -->
	 		<div class="col-lg-9" ng-switch on="selectedTravel">
	 		
				<!-- No travel selected -->
				<div class="panel-body" ng-switch-when="null">
					<div class="jumbotron">
			 			<center>
			 				<h1>No selected travels</h1>
							<p>Enter your travels with your pictures and itinerary</p>
							<a class="btn btn-default" ng-click="setAddTravel()" href="#addTravel" data-toggle="modal">Add Travel</a>
						</center>
					</div>
				</div>
				
				<!-- Selected travel -->
	 			<div class="panel panel-default" ng-switch-default>
	 				<div class="panel-body">
	 					<div class="page-header">
	 						<h3>{{selectedTravel.name}} - <small>{{selectedTravel.year}}</small></h3>	
	 					</div>
	 					
	 					<!--  Carousel -->
	 					<div id="travelCarousel" class="carousel" style="margin-top:20px">
	 						<!--  Indicators -->
	 						<ol class="carousel-indicators">
	 							<li data-target="#travelCarousel" ng-repeat="image in selectedTravel.images | filter:{inCarousel:true}" data-slide-to="{{$index}}" 
	 							    ng-class="{'active': $index == 0, '': $index != 0}">							
	 						</ol>
	 						
	 						<!--  Images -->
	 						<div class="carousel-inner">
	 							<div ng-class="{'item active': $index == 0, 'item': $index != 0}" ng-repeat="image in selectedTravel.images | filter:{inCarousel:true}">
	 								<center><img ng-src="{{image.url}}" alt="{{image.title}}" class="img-responsive" width="100%"></center>
	 								<div class="carousel-caption">
	 									<h3>{{image.title}}</h3>
	 									<p>{{image.description}}</h3>
	 								</div>
	 							</div>
	 						</div>
	 						
	 						<!--  Control -->
	 						<a class="left carousel-control" href="#travelCarousel" data-slide="prev">
	 							<span class="icon-prev"></span>
							</a>
							<a class="right carousel-control" href="#travelCarousel" data-slide="next">
								<span class="icon-next"></span>
							</a>
	 					</div>
	 					<br><br>
	 					
						<!-- img class="featuredImg" src="{{selectedTravel.images[0].url}}" width="100%" -->

						<!-- Map with itinerary -->
						<google-map center="map.center" zoom="map.zoom"
							bounds="map.bounds" events="map.events" options="map.options">
							<marker ng-repeat="marker in map.markers" coords="marker" icon="marker.icon" click="onMarkerClicked(marker)">
								<marker-label content="marker.title" anchor="22 0" class="marker-labels" /> 
								<window  show="marker.showWindow" closeClick="marker.closeClick()">
									<div class="modal-content mapinfowindow" style="border:0px">
										<div class="modal-body">
											<h4>{{marker.title}}</h4>
											<p style="color:blue">{{marker.description}}</p>
										</div>
										<div class="modal-footer">
	 										<button>More info</button>
	 									</div>
									</div>
								</window>
							</marker>
						</google-map>

						<!--  Description and stops -->
						<div>
							<h4 style="margin-top:20px;margin-bottom:20px">{{selectedTravel.description}}</h4>
							<div ng-show="map.markers.length >= 1">
								<h4 >Itinerary</h4>
								<div ng-repeat="marker in map.markers">
									<h5><b>{{marker.title}}:</b></h5>
									<p>{{marker.description}}</p>
									<div class="gray-link" style="text-align: right;">
										<a ng-click="setEditStop(marker)" href="#updateStop" data-toggle="modal">
											<i class="glyphicon glyphicon-edit" title="Update stop"></i>
										</a>
									</div>
								</div>
							</div>
						</div>

					</div>
				</div>
	 		</div>
	 		
		  	<!-- ========================================================================================== -->
		 	<!-- Articles sidebar                                                                           -->
		 	<!-- ========================================================================================== -->
	 		<div class="col-lg-3">
				<!--  Add new travel  -->
				<a style="margin-left: 10px; font-size: 14px; display: inline-block;" ng-click="setAddTravel()" href="#addTravel" data-toggle="modal"
				   ng-show="travels.length != 0"> 
					<i class="glyphicon glyphicon-plus-sign" title="Add Travel"></i> Add Travel
				</a>
				
				<div class="list-group">
	 				<!-- a href="#" class="list-group-item" ng-repeat="travel in filtered = (travels | excludeSelectedTravelFilter:selectedTravel)"-->
	 				<div class="list-group-item" ng-repeat="travel in travels" ng-style="activeStyle(travel)">
	 					<a href="#" class="list-group-item thumbnail" ng-class="{active:travel.id==selectedTravel.id}" style="border:0px;padding:0;margin-bottom:0" ng-click="setSelectedTravel(travel);">
		 					<div>
			 					<h4 class="list-group-item-heading">{{travel.year}} - {{travel.name}}</h4>
			 					<p class="list-group-item-heading" style="overflow:auto">
			 						<div ng-switch on="travel.images.length">
			 							<div ng-switch-when="0">{{travel.description}}</div>
			 							<div ng-switch-default><img ng-src="{{travel.images[0].url}}" width="30px" height="30px" class="left"> {{travel.description}}</img></div>
			 						</div>				
			 					</p>
		 					</div>
		 					<div class="gray-link" ng-class="{active:travel.id==selectedTravel.id}" style="text-align: right;">			
								<a ng-click="setRemoveTravel(travel)" href="#removeTravel" data-toggle="modal">
								    <i class="glyphicon glyphicon-trash" title="Delete travel"></i>
								</a>
								<a ng-click="setUpdateTravel(travel)" href="#updateTravel" data-toggle="modal">
								    <i class="glyphicon glyphicon-edit" title="Update travel"></i>
								</a>
								<a ng-click="setUploadPhotosTravel(travel)" href="#uploadPhotosTravel" data-toggle="modal">
								    <i class="glyphicon glyphicon-camera" title="Upload photos of travel"></i>
								</a>
							</div>
		 				</a>
		 							
						<!-- a href="#" class="btn btn-default pull-right">Read More</a -->
	 				</div>
	 			</div>	 			
	 		</div>
	 	</div>
	 </div>
	 
   	<!-- ========================================================================================== -->
 	<!-- ========================================================================================== -->
 	
 	<!-- ========================================================================================== -->
 	<!-- Sticky footer that stays in the browser viewport                                           -->
 	<!-- ========================================================================================== -->
 	<div class="navbar navbar-default navbar-fixed-bottom">
 		<div class="container">
 			<p class="navbar-text pull-left">Site Built By A. Doueb</p>
 			<!-- a href="http://www.google.fr" class="navbar-btn btn-danger btn pull-right">Goto Google</a -->
 		</div>
 	</div>
 	
  	<!-- ========================================================================================== -->
 	<!-- Add travel dialog                                                                          -->
 	<!-- ========================================================================================== -->
 	<div class="modal fade" id="addTravel" role="dialog" tabindex="-1">
 		<div class="modal-dialog">
		<div class="modal-content">
			<form class="form-horizontal" name="addTravelForm">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4>Add Travel</h4>
				</div>
				<div class="modal-body">
					<div class="alert alert-danger alert-dismissable" ng-show="showAddTravelError">
		  				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
		  				<strong>Error!</strong> The travel can't be added.
					</div>
					
					<div class="form-group">
						<label for="contact-new-country" class="col-lg-2 control-label">Country:</label>
						<div class="col-lg-10">
							<input type="text" class="form-control" id="contact-new-country" name="addTravelCountry" placeholder="Country" ng-model="addTravelData.country" required>
							<span ng-show="showError(addTravelForm.addTravelCountry, 'required')">The country is required</span>
						</div>
					</div>
					<div class="form-group">
						<label for="contact-new-year" class="col-lg-2 control-label">Year:</label>
						<div class="col-lg-10">
							<input type="text" class="form-control" id="contact-new-year" name="addTravelYear" placeholder="2014" ng-model="addTravelData.year" required>
							<span ng-show="showError(addTravelForm.addTravelYear, 'required')">The year is required</span>
						</div>
					</div>
					<div class="form-group">
						<label for="contact-new-name" class="col-lg-2 control-label">Name:</label>
						<div class="col-lg-10">
							<input type="text" class="form-control" id="contact-new-name" name="addTravelName" placeholder="Name"  ng-model="addTravelData.name" required>
							<span ng-show="showError(addTravelForm.addTravelName, 'required')">The name is required</span>
						</div>
					</div>
					<div class="form-group">
						<label for="contact-new-description" class="col-lg-2 control-label">Description:</label>
						<div class="col-lg-10">
							<textarea class="form-control" id="contact-new-description" rows="8" ng-model="addTravelData.description"></textarea>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<a class="btn btn-default" data-dismiss="modal">Close</a>
					<button class="btn btn-primary" ng-click="addTravel()" ng-disabled="!canAddTravel()">Create</button>
				</div>
			</form>
		</div>
	</div>
 	</div>
 	
  	<!-- ========================================================================================== -->
 	<!-- Update travel dialog                                                                       -->
 	<!-- ========================================================================================== -->
 	<div class="modal fade" id="updateTravel" role="dialog" tabindex="-1">
	<div class="modal-dialog">
		<div class="modal-content">
			<form class="form-horizontal">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4>Update Travel</h4>
				</div>
				<div class="modal-body">
					<div class="alert alert-danger alert-dismissable" ng-show="showUpdateTravelError">
		  				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
		  				<strong>Error!</strong> The travel can't be updated.
					</div>
					
					<div class="form-group">
						<label for="contact-update-country" class="col-lg-2 control-label">Country:</label>
						<div class="col-lg-10">
							<input type="text" class="form-control" id="contact-update-country" placeholder="Country" ng-model="currentTravel.country">
						</div>
					</div>
					<div class="form-group">
						<label for="contact-update-year" class="col-lg-2 control-label">Year:</label>
						<div class="col-lg-10">
							<input type="text" class="form-control" id="contact-update-year" placeholder="2014" ng-model="currentTravel.year">
						</div>
					</div>
					<div class="form-group">
						<label for="contact-update-name" class="col-lg-2 control-label">Name:</label>
						<div class="col-lg-10">
							<input type="text" class="form-control" id="contact-update-name" placeholder="Name"  ng-model="currentTravel.name">
						</div>
					</div>
					<div class="form-group">
						<label for="contact-update-description" class="col-lg-2 control-label">Description:</label>
						<div class="col-lg-10">
							<textarea class="form-control" rows="8" id="contact-update-description" ng-model="currentTravel.description"></textarea>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<a class="btn btn-default" data-dismiss="modal">Close</a>
					<button class="btn btn-primary" ng-click="updateTravel(currentTravel)">Update</button>
				</div>
			</form>
		</div>
</div> 	</div>
 	
  	<!-- ========================================================================================== -->
 	<!-- Delete travel dialog                                                                       -->
 	<!-- ========================================================================================== -->
 	<div class="modal fade" id="removeTravel" role="dialog" tabindex="-1">
		<div class="modal-dialog">
			<div class="modal-content">
				<form class="form-horizontal">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
						<h4>Delete Travel</h4>
					</div>
					<div class="alert alert-danger alert-dismissable" ng-show="showDeleteTravelError">
		  				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
		  				<strong>Error!</strong> The travel can't be deleted.
					</div>
							
					<div class="modal-body">
						Do you really want to delete the "{{currentTravel.name}}" travel ?
					</div>
					<div class="modal-footer">
						<a class="btn btn-default" data-dismiss="modal">No</a>
						<button class="btn btn-primary" ng-click="deleteTravel(currentTravel)">Yes</button>
					</div>
				</form>
			</div>
		</div>
	</div>
 	
  	<!-- ========================================================================================== -->
 	<!-- Upload photos dialog                                                                       -->
 	<!-- ========================================================================================== -->
 	<div class="modal fade" id="uploadPhotosTravel" role="dialog" tabindex="-1">
 		<div  class="modal-dialog">
		<div class="modal-content">
			<form class="form-horizontal" name="uploadPhotosTravelForm">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4>Upload photos</h4>
				</div>
				<div class="modal-body">
					<!-- div class="alert alert-danger alert-dismissable" ng-show="showUploadImagesTravelError">
		  				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
		  				<strong>Error!</strong> The photos can't be uploaded.
					</div -->
					
					<div class="container">
					 <!-- The fileupload-buttonbar contains buttons to add/delete files and start/cancel the upload -->
				        <div class="row fileupload-buttonbar">
				            <div class="col-lg-7">
				                <!-- The fileinput-button span is used to style the file input field as button -->
				                <span class="btn btn-success fileinput-button" ng-class="{disabled: disabled}">
				                    <i class="glyphicon glyphicon-plus"></i>
				                    <span>Add files...</span>
				                    <input type="file" ng-file-select="onFileSelect($files)" multiple>
				                    
				                    <!-- file name="uploadPhotos" ng-model="uploadPhotos" accept="image/png,image/jpg,image/jpeg" / -->
				                    <!-- input type="file" multiple ng-disabled="disabled" onchange="TravelListCtrl.prototype.setFile(this)" -->
				                </span>
				                <button type="button" class="btn btn-primary start" data-ng-click="startUploads()">
				                    <i class="glyphicon glyphicon-upload"></i>
				                    <span>Start upload</span>
				                </button>
				                <button type="button" class="btn btn-warning cancel" data-ng-click="abortUploads()">
				                    <i class="glyphicon glyphicon-ban-circle"></i>
				                    <span>Cancel upload</span>
				                </button>
				                <button type="button btn-danger destroy" class="btn" data-ng-click="clearUploads()">
				                    <i class="glyphicon glyphicon-remove-circle"></i>
				                    <span>Clear</span>
				                </button>
				                <!-- The global file processing state -->
				                <span class="fileupload-process"></span>
				            </div>
				             
				            <!-- The global progress state -->
				            <div class="col-lg-5 fade" data-ng-class="{in: active()}">
				                <!-- The global progress bar -->
				                <div class="progress progress-striped active" data-file-upload-progress="progress()">
				                	<div class="progress-bar progress-bar-success" data-ng-style="{width: num + '%'}"></div>
				                </div>
				                <!-- The extended global progress state -->
				                <div class="progress-extended">&nbsp;</div>
				            </div>
				        </div>
				        
				        <!-- The table listing the files available for upload/download -->
	        			<table class="table-striped files ng-cloak">
				            <tr data-ng-repeat="file in selectedFiles" data-ng-class="{'processing': file.$processing()}">
				            	<td width="70px" valign="center" padding="10px">
				                	<img class="thumbnail" ng-show="dataUrls[$index]" ng-src="{{dataUrls[$index]}}" width="60px" height="60px" ></img>
				                </td>
				                <td width="150px" valign="center" padding="10px">
				                	<div>{{file.name}}</div>
				                </td>
				                <td width="150px" valign="center" padding="10px">
				                	<label>Title:</label>
				                	<input type="text" placeholder="Title" ng-model="file.title">
				                </td>
				                <td width="300px" valign="center" padding="10px" border="1px">
				                	<label>Description:</label>
				                	<textarea rows="1" cols="50" placeholder="Description"  ng-model="file.description"></textarea>
				                </td>
				                <td width="200px" valign="center" padding="10px">
				                	<span class="progress" ng-show="progress[$index] >= 0">	
				                		<div ng-switch on="results[$index].length">
			 								<div ng-switch-when="0"><div class="progress-bar progress-bar-success" style="border-style:solid;border-width:1px;width:{{progress[$index]}}%">{{progress[$index]}}%</div></div>
			 								<div ng-switch-default><div class="progress-bar progress-bar-danger" style="border-style:solid;border-width:1px;width:100%">{{results[$index]}}</div></div>
			 							</div>					
										
									</span>	
				                </td>
					            <td width="70px" valign="center" padding="10px">
				                	<button type="button" class="btn btn-danger destroy" ng-click="deleteSelectedFile($index)">
				                        <i class="glyphicon glyphicon-trash"></i>
				                        <span>Delete</span>
				                    </button>
				                </td>
				            </tr>
				        </table>
        			</div>
					
					<div class="form-group">
					</div>
				</div>
				<div class="modal-footer">
					<a class="btn btn-primary"  ng-click="closeUpload()" data-dismiss="modal">Close</a>
				</div>
			</form>
		</div>
	</div>
 	</div>
 	
  	<!-- ========================================================================================== -->
 	<!-- Contact dialog                                                                             -->
 	<!-- ========================================================================================== -->
 	<div class="modal fade" id="contact" role="dialog" tabindex="-1">
 		<div class="modal-dialog">
 			<div class="modal-content">
 				<form class="form-horizontal">
	 				<div class="modal-header">
	 					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	 					<h4>Contact My Travels</h4>
	 				</div>
	 				<div class="modal-body">
	 					<div class="form-group">
	 						<label for="contact-email" class="col-lg-2 control-label">E-mail:</label>
	 						<div class="col-lg-10">
	 							<input type="email" class="form-control" id="contact-email" placeholder="you@example.com" ng-model="email.address">
	 						</div>
	 					</div>
	 					<div class="form-group">
	 						<label for="contact-subject" class="col-lg-2 control-label">Subject:</label>
	 						<div class="col-lg-10">
	 							<input type="text" class="form-control" id="contact-subject" placeholder="Subject"  ng_model="email.subject">
	 						</div>
	 					</div>
	 					<div class="form-group">
	 						<label for="contact-message" class="col-lg-2 control-label">Message:</label>
	 						<div class="col-lg-10">
	 							<textarea class="form-control" rows="8" ng-model="email.body"></textarea>
	 						</div>
	 					</div>
	 				</div>
	 				<div class="modal-footer">
	 					<a class="btn btn-default" data-dismiss="modal">Close</a>
	 					<button class="btn btn-primary" ng-click="sendEmail();" data-dismiss="modal">Send</button>
	 				</div>
 				</form>
 			</div>
 		</div>
 	</div>
 	
  	<!-- ========================================================================================== -->
 	<!-- Edit stop                                                                                -->
 	<!-- ========================================================================================== -->
 	<div class="modal fade" id="updateStop" role="dialog" tabindex="-1">
 		<div class="modal-dialog">
 			<div class="modal-content">
 				<form class="form-horizontal">
	 				<div class="modal-header">
	 					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	 					<h4>Update Stop</h4>
	 				</div>
	 				<div class="modal-body">
						<div class="alert alert-danger alert-dismissable" ng-show="showEditStopError">
			  				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
			  				<strong>Error!</strong> The stop can't be updated.
						</div>

	 					<div class="form-group">
	 						<label for="stop-update-title" class="col-lg-2 control-label">Title:</label>
	 						<div class="col-lg-10">
	 							<input type="text" class="form-control" id="stop-update-title" placeholder="Title"  ng-model="currentStop.title">
	 						</div>
	 					</div>
	 					<div class="form-group">
	 						<label for="stop-update-description" class="col-lg-2 control-label">Description:</label>
	 						<div class="col-lg-10">
	 							<textarea class="form-control" rows="8" id="stop-update-description" ng-model="currentStop.description"></textarea>
	 						</div>
	 					</div>
	 				</div>
	 				<div class="modal-footer">
	 					<a class="btn btn-default" data-dismiss="modal">Close</a>
	 					<button class="btn btn-primary" ng-click="updateStop(currentStop)">Update</button>
	 				</div>
 				</form>
 			</div>
 		</div>
 	</div>
 	 
    </body>
</html>
