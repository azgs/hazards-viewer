import gdal
import numpy

clip_file = "fireriskindex.tif"
whole_file = "/Users/adrian/Documents/azgs/hazards-viewer-scripts/fri_reclass.tif"
sample_x = -110.76127
sample_y = 32.46144

class GDALCalculateArea:

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

	def compute_x_offset(self, xcoord):
		return int((xcoord - self.xOrigin)/ self.pixelWidth)

	def compute_y_offset(self, ycoord):
		return int((ycoord - self.yOrigin)/ self.pixelHeight)

	def get_raster_attrs(self):
		return self.band.ReadAsArray(0,0,self.cols,self.rows)

	def get_raster_mean(self):
		data = self.get_raster_attrs()
		flat = [a for b in data for a in b]
		length = len(flat)
		mean = reduce(lambda x, y: x + y, flat)/ length
		return mean

	def get_cell_value(self, xcoord, ycoord):
		x = self.compute_x_offset(xcoord)
		y = self.compute_y_offset(ycoord)
		data = self.band.ReadAsArray(x,y,1,1)
		return data[0,0]



z = GDALCalculateArea(clip_file)
print z.get_raster_mean()
print z.get_cell_value(sample_x, sample_y)
