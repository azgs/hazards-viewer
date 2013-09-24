import gdal

class GDALCalculateArea:

	"""
	Problem: How do we compute zonal stats from a raster
		given only a bounding box from geoserver?

	Geoserver Bounding Box = [LEFT,BOTTOM,RIGHT,TOP]
	So, corner coordinates = 
		A:(LEFT,TOP)
		B:(LEFT,BOTTOM)
		C:(RIGHT,BOTTOM)
		D:(RIGHT,TOP)

	* ------------------------> *
	|  A |					| D
	| ___|__________________|____
	|  	 |					|
	|	 |					|
	|	 |					|
	|	 |					|
	|	 |					|
	|	 |					|
	| ___|__________________|____
	v  B |					| C
	*  	 |					|

	Main restriction is that GDAL cannot read negative
	dimensions, so our only option is to read left to 
	right and top to bottom.  (A) will be our origin,
	(B) will be our row extent and (D) will be our column
	extent.  From there, GDAL will return a 2D array of
	values that we can math and science with.

	Note: GDAL reads the value in the top-left corner of 
		a cell as the value of the entire cell.  This is 
		hardcoded into GDAL and cannot be changed (unless
		you want to learn C)
	"""

	def __init__(self, filepath):
		#Set GeoTiff driver
		self.driver = gdal.GetDriverByName("GTiff")
		self.driver.Register()

		#Open raster and read number of rows, columns, bands
		self.dataset = gdal.Open(filepath)
		self.cols = self.dataset.RasterXSize
		self.rows = self.dataset.RasterYSize
		self.allBands = self.dataset.RasterCount
		self.band = self.dataset.GetRasterBand(1)

		#Get raster georeference info
		self.transform = self.dataset.GetGeoTransform()
		self.xOrigin = self.transform[0]
		self.yOrigin = self.transform[3]
		self.pixelWidth = self.transform[1]
		self.pixelHeight = self.transform[5]

	#Take bbox and make a dictionary tailored to this class
	#out of ift
	def get_bbox_corner_coords(self, boundingbox):
		bbox = boundingbox
		keys = ['origin','bottomleft','bottomright','topright']
		bbox_tuples = [(bbox[0],bbox[3]),
					   (bbox[0],bbox[1]),
					   (bbox[2],bbox[1]),
					   (bbox[2],bbox[3])]
		return dict(zip(keys,bbox_tuples))

	def compute_x_offset(self, xcoord):
		return int((xcoord - self.xOrigin)/ self.pixelWidth)

	def compute_y_offset(self, ycoord):
		return int((ycoord - self.yOrigin)/ self.pixelHeight)

	def compute_pixel_extent(self):
		keys = ['pixels_x','pixels_y']
		coords = self.get_bbox_corner_coords(bbox)
		originX = coords['origin'][0]
		originY = coords['origin'][1]
		extentX = coords['topright'][0] - originX
		extentY = coords['bottomleft'][1] - originY
		pixelExtentX = int(extentX / self.pixelWidth)
		pixelExtentY = int(extentY / self.pixelHeight)
		return dict(zip(keys,[pixelExtentX,pixelExtentY]))

	def get_raster_attrs(self):
		return self.band.ReadAsArray(0,0,self.cols,self.rows)

	def get_zone_mean(self, dataset):
		data = dataset
		flat = [int(a) for b in data for a in b]
		length = len(flat)
		mean = reduce(lambda x, y: x + y, flat)/ length
		return mean

	def get_cell_value(self, xcoord, ycoord):
		x = self.compute_x_offset(xcoord)
		y = self.compute_y_offset(ycoord)
		data = self.band.ReadAsArray(x,y,1,1)
		return data[0,0]

	def get_raster_zone(self, boundingbox):
		coords = self.get_bbox_corner_coords(boundingbox)
		pixelExtents = self.compute_pixel_extent()
		originX = self.compute_x_offset(coords['origin'][0])
		originY = self.compute_y_offset(coords['origin'][1])
		extentX = pixelExtents['pixels_x']
		extentY = pixelExtents['pixels_y']
		data = self.band.ReadAsArray(originX,originY,extentX,extentY)
		return data

	def get_mean(self, geom):
		if len(geom) = 2:
			xcoord = geom[0]
			ycoord = geom[1]
			return self.get_cell_value(xcoord,ycoord)
		elif len(geom) = 4:
			data = self.get_raster_zone(geom)
			return self.get_zone_mean(data)
		else:
			error_message = """Sorry, this function only supports 
								point geometries in the form [x,y] 
								and bounding box queries in the form 
								[left,bottom,right,top]."""
			return error_message