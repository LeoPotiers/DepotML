#Usage:
# Create train data:
#python3 xml_to_csv.py -i [PATH_TO_IMAGES_FOLDER]/train -o [PATH_TO_ANNOTATIONS_FOLDER]/train_labels.csv
#python3 xml_to_csv.py -i /tensorflow/models-master/research/DepotML/Train -o /tensorflow/models-master/research/DepotML/data/train_labels.csv

# Create test data:
#python3 xml_to_csv.py -i [PATH_TO_IMAGES_FOLDER]/test -o [PATH_TO_ANNOTATIONS_FOLDER]/test_labels.csv
#python3 xml_to_csv.py -i /tensorflow/models-master/research/DepotML/Test -o /tensorflow/models-master/research/DepotML/data/test_labels.csv

import os
import glob
import pandas as pd
import argparse
import xml.etree.ElementTree as ET


def xml_to_csv2(path):
    xml_list = []
    for xml_file in glob.glob(path + '/*.xml'):
        tree = ET.parse(xml_file)
        root = tree.getroot()
        for member in root.findall('object'):
            #value = (root.find('filename').text,
            #        int(root.find('size')[0].text),
            #        int(root.find('size')[1].text),
            #        member[0].text,
            #        int(member[5][0].text),
            #        int(member[5][1].text),
            #        int(member[5][2].text),
            #        int(member[5][3].text)
            value = (root.find('filename').text,
                    int(root.find('size').find('width').text),
                    int(root.find('size').find('height').text),
                    member[0].text,
                    int(member.find("bndbox").find('xmin').text),
                    int(member.find("bndbox").find('ymin').text),
                    int(member.find("bndbox").find('xmax').text),
                    int(member.find("bndbox").find('ymax').text)
                    )
            xml_list.append(value)
    column_name = ['filename', 'width', 'height',
                'class', 'xmin', 'ymin', 'xmax', 'ymax']
    xml_df = pd.DataFrame(xml_list, columns=column_name)
    return xml_df


def main():
    # Initiate argument parser
    parser = argparse.ArgumentParser(
        description="Sample TensorFlow XML-to-CSV converter")
    parser.add_argument("-i",
                        "--inputDir",
                        help="Path to the folder where the input .xml files are stored",
                        type=str)
    parser.add_argument("-o",
                        "--outputFile",
                        help="Name of output .csv file (including path)", type=str)
    args = parser.parse_args()

    if(args.inputDir is None):
        args.inputDir = os.getcwd()
    if(args.outputFile is None):
        args.outputFile = args.inputDir + "/labels.csv"

    assert(os.path.isdir(args.inputDir))

    xml_df = xml_to_csv2(args.inputDir)
    xml_df.to_csv(
        args.outputFile, index=None)
    print('Successfully converted xml to csv.')


if __name__ == '__main__':
    main()
