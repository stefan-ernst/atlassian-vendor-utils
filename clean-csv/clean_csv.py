#!/usr/bin/env python3

import csv
import os
import sys

def clean_csv(file_name):
    output_file_name = os.path.splitext(file_name)[0] + '_cleaned.csv'
    columns_to_keep = ['maintenanceEndDate','addonKey', 'company', 'evaluationOpportunitySize']

    with open(file_name, mode='r', newline='') as input_file:
        csv_reader = csv.DictReader(input_file)
        with open(output_file_name, mode='w', newline='') as output_file:
            csv_writer = csv.DictWriter(output_file, fieldnames=columns_to_keep)
            csv_writer.writeheader()
            for row in csv_reader:
                filtered_row = {k: row[k] for k in columns_to_keep if k in row}
                csv_writer.writerow(filtered_row)

    print(f'Cleaned CSV saved as: {output_file_name}')


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('Usage: ./clean_csv.py input_file.csv')
        sys.exit(1)

    file_name = sys.argv[1]
    clean_csv(file_name)
