<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Hello World!</title>

		<style>
			h1 {
				font-size: 70px; 
				font-weight: 100;
				font-color: #7a7a52;
				font-family : Century Gothic, sans-serif;
				position: absolute;
				width: 100%;
				text-align: center;
				top: 30%;
			}
			body {
				color: #7a7a52;
				font-family : "Courier New", Courier, monospace;
				font-size:13px;
				text-align:center;
				background-color: #000000;
				margin: 0px;
				overflow: hidden;
			}
			#info {
				position: absolute;
				top: 0px; width: 100%;
				padding: 5px;
			}
			a {
				color: #0080ff;
			}
			#transbox {
				position: absolute;
				width: 70%;
				top: 80%;
				left: 50%;
  				transform: translate(-50%, -50%);
				height : 30%;
  				background-color: #ffffff;
  				opacity: 0.1;
  				filter: alpha(opacity=40); /* For IE8 and earlier */
			}
		
			.title{
				font-size: 70px; 
				font-color: #7a7a52;
				font-family : "Courier New", Courier, monospace;
				position: absolute;
				width: 100%;
				text-align: center;
				top: 30%;
			}
			
			head{
				font-size: 70px; 
				font-color: #7a7a52;
				top: 20%;
				margin: 5%;
				font-size : 60px;
			}
			h6 {
  				text-align: center;
  				font-weight: 100;
  				top: 60%;
  				position: absolute;
				width: 100%;
  				font-family : Century Gothic, sans-serif;
  				font-size : 30px;
  				color: #999966;
  				}
  			.btn-group .button {
  				position: absolute;
  				background-color: #7a7a52;
  				border: none;
  				color: white;
  				top: 80%;
  				padding: 16px 32px;
  				text-align: center;
  				font-size: 16px;
  				margin: 4px 2px;
  				opacity: 0.6;
  				transition: 0.3s;
  				display: inline-block;
  				text-decoration: none;
  				cursor: pointer;
				}
		.btn-group .button:not(:last-child) {
  				border-right: none; /* Prevent double borders */
				}
		.btn-group button:hover {opacity: 1}
		</style>
</head>
<body>
	<h1>SUZUKA KOKUBU</h1>
	<!-- <p class = "title">SUZUKA KOKUBU</p> -->
	<div id="transbox">
  	</div>
  	<h6>Thanks for visiting my webpage!</h6>
  	<div class="btn-group">
  		<button class="button">About me</button>
  		<button class="button">Project</button>
  	</div>
	<div id="container"></div>

	<script src="dat.gui.min.js"></script>
	<script src="three.js"></script>
	<script src="OrbitControls.js"></script>
	<script src="stats.min.js"></script>
	
<script>
			var group;
			var container, stats;
			var particlesData = [];
			var camera, scene, renderer;
			var positions, colors;
			var particles;
			var pointCloud;
			var particlePositions;
			var linesMesh;
			var maxParticleCount = 1000;
			var particleCount = 500;
			var r = 2000;
			var rHalf = r / 2;
			var effectController = {
				showDots: false,
				showLines: true,
				minDistance: 250,
				limitConnections: false,
				maxConnections: 1,
				particleCount: 100
			};
			init();
			animate();
			function initGUI() {
				var gui = new dat.GUI();
				gui.add( effectController, "showDots" ).onChange( function ( value ) {
					pointCloud.visible = value;
				} );
				gui.add( effectController, "showLines" ).onChange( function ( value ) {
					linesMesh.visible = value;
				} );
				gui.add( effectController, "minDistance", 10, 300 );
				gui.add( effectController, "limitConnections" );
				gui.add( effectController, "maxConnections", 0, 30, 1 );
				gui.add( effectController, "particleCount", 0, maxParticleCount, 1 ).onChange( function ( value ) {
					particleCount = parseInt( value );
					particles.setDrawRange( 0, particleCount );
				} );
			}
			
			function init() {
				//initGUI();
				
				container = document.getElementById( 'container' );
				
				camera = new THREE.PerspectiveCamera( 45, window.innerWidth / window.innerHeight, 1, 4000 );
				camera.position.z = 1750;
				
				//var controls = new THREE.OrbitControls( camera, container );
				
				scene = new THREE.Scene();
				group = new THREE.Group();
				scene.add( group );
				
				var segments = maxParticleCount * maxParticleCount;
				
				positions = new Float32Array( segments * 3 ); //type specified array is faster than normal array
				colors = new Float32Array( segments * 3 );
				
				var pMaterial = new THREE.PointsMaterial( {
					color: 0xFFFFFF,
					size: 1,
					blending: THREE.AdditiveBlending,
					transparent: true,
					sizeAttenuation: false
				} );
				
				particles = new THREE.BufferGeometry();
				particlePositions = new Float32Array( maxParticleCount * 3 );
				
				for ( var i = 0; i < maxParticleCount; i ++ ) {
					var x = Math.random() * r - r / 2;
					var y = Math.random() * r - r / 2;
					var z = Math.random() * r - r / 2;
					
					particlePositions[ i * 3     ] = x;
					particlePositions[ i * 3 + 1 ] = y;
					particlePositions[ i * 3 + 2 ] = z;
					
					// add it to the geometry
					particlesData.push( {
						velocity: new THREE.Vector3( - 1 + Math.random() * 2, - 1 + Math.random() * 2, - 1 + Math.random() * 2 ),
						numConnections: 0
					} );
				}
				
				particles.setDrawRange( 0, particleCount );
				particles.addAttribute( 'position', new THREE.BufferAttribute( particlePositions, 3 ).setDynamic( true ) );
				
				// create the particle system
				pointCloud = new THREE.Points( particles, pMaterial );
				group.add( pointCloud );
				
				var geometry = new THREE.BufferGeometry();
				geometry.addAttribute( 'position', new THREE.BufferAttribute( positions, 3 ).setDynamic( true ) );
				geometry.addAttribute( 'color', new THREE.BufferAttribute( colors, 3 ).setDynamic( true ) );
				geometry.computeBoundingSphere();
				geometry.setDrawRange( 0, 0 );
				var material = new THREE.LineBasicMaterial( {
					vertexColors: THREE.VertexColors,
					blending: THREE.AdditiveBlending,
					transparent: true
				} );
				linesMesh = new THREE.LineSegments( geometry, material );
				group.add( linesMesh );
				//
				renderer = new THREE.WebGLRenderer( { antialias: true } );
				renderer.setPixelRatio( window.devicePixelRatio );
				renderer.setSize( window.innerWidth, window.innerHeight );
				renderer.gammaInput = true;
				renderer.gammaOutput = true;
				container.appendChild( renderer.domElement );
				//
				stats = new Stats();
				container.appendChild( stats.dom );
				window.addEventListener( 'resize', onWindowResize, false );
			}
			function onWindowResize() {
				camera.aspect = window.innerWidth / window.innerHeight;
				camera.updateProjectionMatrix();
				renderer.setSize( window.innerWidth, window.innerHeight );
			}
			function animate() {
				var vertexpos = 0;
				var colorpos = 0;
				var numConnected = 0;
				for ( var i = 0; i < particleCount; i ++ )
					particlesData[ i ].numConnections = 0;
				for ( var i = 0; i < particleCount; i ++ ) {
					// get the particle
					var particleData = particlesData[ i ];
					particlePositions[ i * 3 ] += particleData.velocity.x;
					particlePositions[ i * 3 + 1 ] += particleData.velocity.y;
					particlePositions[ i * 3 + 2 ] += particleData.velocity.z;
					if ( particlePositions[ i * 3 + 1 ] < - rHalf || particlePositions[ i * 3 + 1 ] > rHalf )
						particleData.velocity.y = - particleData.velocity.y;
					if ( particlePositions[ i * 3 ] < - rHalf || particlePositions[ i * 3 ] > rHalf )
						particleData.velocity.x = - particleData.velocity.x;
					if ( particlePositions[ i * 3 + 2 ] < - rHalf || particlePositions[ i * 3 + 2 ] > rHalf )
						particleData.velocity.z = - particleData.velocity.z;
					if ( effectController.limitConnections && particleData.numConnections >= effectController.maxConnections )
						continue;
					// Check collision
					for ( var j = i + 1; j < particleCount; j ++ ) {
						var particleDataB = particlesData[ j ];
						if ( effectController.limitConnections && particleDataB.numConnections >= effectController.maxConnections )
							continue;
						var dx = particlePositions[ i * 3 ] - particlePositions[ j * 3 ];
						var dy = particlePositions[ i * 3 + 1 ] - particlePositions[ j * 3 + 1 ];
						var dz = particlePositions[ i * 3 + 2 ] - particlePositions[ j * 3 + 2 ];
						var dist = Math.sqrt( dx * dx + dy * dy + dz * dz );
						if ( dist < effectController.minDistance ) {
							particleData.numConnections ++;
							particleDataB.numConnections ++;
							var alpha = 1.0 - dist / effectController.minDistance;
							positions[ vertexpos ++ ] = particlePositions[ i * 3 ];
							positions[ vertexpos ++ ] = particlePositions[ i * 3 + 1 ];
							positions[ vertexpos ++ ] = particlePositions[ i * 3 + 2 ];
							positions[ vertexpos ++ ] = particlePositions[ j * 3 ];
							positions[ vertexpos ++ ] = particlePositions[ j * 3 + 1 ];
							positions[ vertexpos ++ ] = particlePositions[ j * 3 + 2 ];
							colors[ colorpos ++ ] = alpha;
							colors[ colorpos ++ ] = alpha;
							colors[ colorpos ++ ] = alpha;
							colors[ colorpos ++ ] = alpha;
							colors[ colorpos ++ ] = alpha;
							colors[ colorpos ++ ] = alpha;
							numConnected ++;
						}
					}
				}
				linesMesh.geometry.setDrawRange( 0, numConnected * 2 );
				linesMesh.geometry.attributes.position.needsUpdate = true;
				linesMesh.geometry.attributes.color.needsUpdate = true;
				pointCloud.geometry.attributes.position.needsUpdate = true;
				requestAnimationFrame( animate );
				stats.update();
				render();
			}
			function render() {
				var time = Date.now() * 0.001;
				group.rotation.y = time * 0.1;
				renderer.render( scene, camera );
			}
		</script>
</body>
</html>