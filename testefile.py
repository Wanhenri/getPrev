import xarray as xr
import cartopy.crs as ccrs
import matplotlib.pyplot as plt
import cartopy

path = "/dados/dmdpesq/BAM_grib2/etapa2/12/"
name_file = "BAM.t12z.f24.anl2019111012.prev20191111_APCP.grib2.nc"
DS_NCEP = xr.open_dataset(path + name_file)

lons = DS_NCEP.variables['longitude'][:]
lats = DS_NCEP.variables['latitude'][:]
da = DS_NCEP.APCP_surface.mean('time')
fig, ax = plt.subplots(111,figsize=(15,15), dpi=200)
ax = plt.axes(projection=ccrs.PlateCarree())
clevs=[-70,2,4,6,8,10,12,14,16,18,70]
color=['white','dodgerblue','darkturquoise','mediumspringgreen','lime','yellow',
       'orange','goldenrod','red','firebrick']
         
cp = plt.contourf(lons,lats,da, clevs, colors=color,zorder=1)

ax.coastlines(resolution='110m')
ax.add_feature(cartopy.feature.BORDERS, linestyle=':')
#for BR
ax.set_extent([-85, -30, -60, 15])
ax.stock_img()
ax.set_title(
                      ' BRAZILIAN ATMOSPHERIC MODEL (BAM) 666' 
                     + '\n' 
                     + '20140101 12Z ' 
                     + '\n',
                     fontsize=18
)
fig.colorbar(cp, orientation='horizontal',pad=0.05)
fig.set_label('mm')
title = ('teste.png')
plt.savefig(title, bbox_inches='tight', pad_inches=.2, dpi=300)
print('Saved: {}'.format(title))
plt.close()        
DS_NCEP.close()
