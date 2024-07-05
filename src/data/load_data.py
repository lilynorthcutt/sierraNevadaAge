###########################################
## Reading in SHAPEFILES
############################################
def read_shapefiles_in_folder(folder_path):
    'FUNCTION TO READ IN ALL SHAPEFILES FROM A FOLDERPATH'
    shapefiles_dict = {}

    # Check if the folder path exists
    if not os.path.exists(folder_path):
        raise FileNotFoundError(f"The folder '{folder_path}' does not exist.")

    # Iterate through files in the folder
    for filename in os.listdir(folder_path):
        if filename.endswith(".shp"):
            file_path = os.path.join(folder_path, filename)

            # Extract file name without extension
            file_name = os.path.splitext(filename)[0]

            # Read shapefile into GeoDataFrame
            gdf = gpd.read_file(file_path)

            # Store GeoDataFrame in the dictionary
            shapefiles_dict[file_name] = gdf

    return shapefiles_dict

