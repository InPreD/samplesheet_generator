# samplesheet_generator
generates samplesheet compatible with TSO500 LocalApp analysis.

## Contents

1. [Introduction](#introduction)
2. [Dependencies](#dependencies)
3. [Description of Input Parameters](#description-of-input-parameters)
4. [Usage](#usage)

## Introduction

Running LocalApp analysis requires a samplesheet in a specific format consistent with the performed sequencing to guide the analysis. Such a samplesheet can be created manually using a template samplesheet file provided by Illumina and filling in a run specific information for every sequencing run using Excel or similar. This script is an attempt to automatize the task of samplesheet generation as much as possible. The script gets a sequencing run information in a simple `tab` separated table and generates a samplesheet fulfilling LocalApp requirements.


## Dependencies

- python3>=3.9, 
- pandas==2.2.0


## Description of Input Parameters

Names of the input parameters defined for the script and their possible values are listed in the table below.


| parameter | description | type | default |
|:---|:---|:---:|:---:|
|`--run-id`| ID of the sequencing run for which the samplesheet is generated. | str | |
|`--index-type`| Type of the used index. Supported values are `dual` and `simple`. | str | `dual` |
|`--index-length`| Number of nucleotides in the used index. Supported values are `8` and `10`. | int | |
|`--investigator-name`| Value of the `Investigator Name` field in the samplesheet. It is preferred for the string to be in the form `name (inpred_node)`. The string cannot contain a comma. | str | `''` | 
|`--experiment-name`| Value of the `Experiment Name` field in the samplesheet. It is preferred for the string to be a space separated list of all the studies from which the run samples are. The string cannot contain a comma. | str | `''` |
|`--input-info-file`| Absolute path to an input info file. | str | |
|`--read-length-1`| Length of the sequenced forward reads. This value will be filled in the `Reads` section of the samplesheet. | int | `101` |
|`--read-length-2`| Length of the sequenced reverse reads. This value will be filled in the `Reads` section of the samplesheet. | int | `101` |
|`--adapter-read-1`| Nucleotide adapter sequence of read1. This value will be filled in the `Settings` section of the samplesheet. | str | |
|`--adapter-read-2`| Nucleotide adapter sequence of read2. This value will be filled in the `Settings` section of the samplesheet. | str | |
|`--adapter-behavior`| This value will be filled in the `Settings` section of the samplesheet and passed as an input parameter to BCL convert. Supported values are `trim` and `mask`. For more info about BCL convert, see the [BCL convert user guide](https://support.illumina.com/sequencing/sequencing_software/bcl-convert.html). | str | `trim` |
|`--minimum-trimmed-read-length`| This value will be filled in the `Settings` section of the samplesheet and passed as an input parameter to BCL convert. | int |  `35` |
|`--mask-short-reads`| This value will be filled in the `Settings` section of the samplesheet and passed as an input parameter to BCL convert. | int | `22` |
|`--override-cycles`| This value will be filled in the `Settings` section of the samplesheet and passed as an input parameter to BCL convert. | str | | 
|`--samplesheet-version`| Version in which the samplesheet is generated. Only `v1` is implemented now. | str | `v1` |
|`--help`|Print the help message and exit.| | |

File format of the `input_info_file` follows.

### Input Info File Format

The file is expected to contain `tab` separated values (`.tsv` file). The rows starting with character `#` are ignored (considered to be comments). The first non-commented row is considered to be a header containing column names.

Required columns of the file are: `sample_id`, `molecule`, `run_id`, `barcode`, `index` (at least one of columns `barcode` and `index` has to be non-empty).

| column | description |
|:---|:---|
|`sample_id`| - id of a sample.|
|`molecule` | - `DNA` or `RNA`, choose the appropriate one.| 
| `run_id`  | - id of the sequencing run in which the sample was sequenced. |
| `barcode` | - one of the `Index_ID` values from the `indexes/TSO500*_dual_*.tsv` files or one of the `I7_Index_ID` values from the `indexes/TSO500*simple*.tsv` file. The value should correspond to the indexes used for sequencing of the sample. Alternatively, the field can be left empty or containing `NA` string.| 
| `index`   | - DNA sequence of the forward index from the column `index` from one of the `indexes/*.tsv` files. Alternatively, the field can be left empty or containing `NA` string.|

### Used Parameter Value Combinations

```
# nextseq instrument, dual indexes, index length 8
--index-type dual \
--index-length 8 \
--read-length-1 101 \
--read-length-2 101 \
--adapter-read-1 "AGATCGGAAGAGCACACGTCTGAACTCCAGTCA" \
--adapter-read-2 "AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT" \
--adapter-behavior "trim" \
--minimum-trimmed-read-length 35 \
--mask-short-reads 35 \
--override-cycles "U7N1Y93;I8;I8;U7N1Y93"
```

```
# novaseq instrument, dual indexes, index length 10 
--index-type dual \
--index-length 10 \
--read-length-1 101 \
--read-length-2 101 \
--adapter-read-1 "CTGTCTCTTATACACATCTCCGAGCCCACGAGAC" \
--adapter-read-2 "CTGTCTCTTATACACATCTGACGCTGCCGACGA" \
--adapter-behavior "trim" \
--minimum-trimmed-read-length 35 \
--mask-short-reads 35 \
--override-cycles "U7N1Y93;I10;I10;U7N1Y93"
```

```
# nextseq instrument, simple indexes, index length 8, legacy
--index-type simple \
--index-length 8 \
--read-length-1 101 \
--read-length-2 101 \
--adapter-read-1 "AGATCGGAAGAGCACACGTCTGAACTCCAGTCA" \
--adapter-read-2 "AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT" \
--adapter-behavior "trim" \
--minimum-trimmed-read-length 35 \
--mask-short-reads 22 \
--override-cycles "U7N1Y93;I8;I8;U7N1Y93"
```

## Usage

### Running locally

```
python3 generate_samplesheet.py [parameters]...
```

### Docker

```
docker run --rm -it \
	-v /path_input_file:/container_path_input_file \
	inpred/samplesheet_generator:latest bash
```

### Singularity/Apptainer

```
singularity run \
	-B /path_input_file:/container_path_input_file \
	docker://inpred/samplesheet_generator:latest bash	
	
apptainer run \
	-B /path_input_file:/container_path_input_file \
	docker://inpred/samplesheet_generator:latest bash	
```

### Run Test Data Example

Test data are located in the `test` subfolder of the repository. Input info file is named `infoFile.tsv` and expected output is stored in `samplesheet.tsv`.

The script is tested with data of a specific sequencing run. The run consists of artificial samples, including AcroMetrix samples. The sequencing was performed on a NextSeq instrument, with the legacy parameter setting and file formats.


#### Locally

```
# ${GITHUB_REPOSITORY_LOCAL_PATH} is an absolute path 
# to the samplesheet_generator repository on on the local compute.

# define the testRunID value
testRunID="191206_NB501498_0174_AHWCNMBGXC"

# execute samplesheet_generator
python3 samplesheet_generator.py \
	--run-id ${testRunID} \
	--index-type simple \
	--index-length 8 \
	--investigator-name "Name (InPreD node)" \
	--experiment-name "OUS pathology test run" \
	--input-info-file ${GITHUB_REPOSITORY_LOCAL_PATH}/test/infoFile.tsv \
	--read-length-1 101 \
	--read-length-2 101 \
	--adapter-read-1 "AGATCGGAAGAGCACACGTCTGAACTCCAGTCA" \
	--adapter-read-2 "AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT" \
	--adapter-behavior "trim" \
	--minimum-trimmed-read-length 35 \
	--mask-short-reads 22 \
	--override-cycles "U7N1Y93;I8;I8;U7N1Y93" \
	--samplesheet-version "v1"
```

#### Docker

```
# ${GITHUB_REPOSITORY_LOCAL_PATH} is an absolute path 
# to the samplesheet_generator repository on on the local compute.
# ${INFO_INPUT_FILE_CONTAINER} is an absolute path to the input info file 
# in the container. 

docker run --rm -it \
	-v ${GITHUB_REPOSITORY_LOCAL_PATH}/test/infoFile.tsv:${INFO_INPUT_FILE_CONTAINER} \
	docker://inpred/samplesheet_generator:latest bash

Docker> testRunID="191206_NB501498_0174_AHWCNMBGXC"
Docker> python3 samplesheet_generator.py \
		--run-id ${testRunID} \
		--index-type simple \
		--index-length 8 \
		--investigator-name "Name (InPreD node)" \
		--experiment-name "OUS pathology test run" \
		--input-info-file ${INFO_INPUT_FILE_CONTAINER} \
		--read-length-1 101 \
		--read-length-2 101 \
		--adapter-read-1 "AGATCGGAAGAGCACACGTCTGAACTCCAGTCA" \
		--adapter-read-2 "AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT" \
		--adapter-behavior "trim" \
		--minimum-trimmed-read-length 35 \
		--mask-short-reads 22 \
		--override-cycles "U7N1Y93;I8;I8;U7N1Y93" \
		--samplesheet-version "v1"
```

#### Singularity/Apptainer

```
singularity run \
	-B ${GITHUB_REPOSITORY_LOCAL_PATH}/test/infoFile.tsv:${INFO_INPUT_FILE_CONTAINER} \
	docker://inpred/samplesheet_generator:latest bash

Singularity> testRunID="191206_NB501498_0174_AHWCNMBGXC"
Singularity> python3 samplesheet_generator.py \
		--run-id ${testRunID} \
		--index-type simple \
		--index-length 8 \
		--investigator-name "Name (InPreD node)" \
		--experiment-name "OUS pathology test run" \
		--input-info-file ${INFO_INPUT_FILE_CONTAINER} \
		--read-length-1 101 \
		--read-length-2 101 \
		--adapter-read-1 "AGATCGGAAGAGCACACGTCTGAACTCCAGTCA" \
		--adapter-read-2 "AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT" \
		--adapter-behavior "trim" \
		--minimum-trimmed-read-length 35 \
		--mask-short-reads 22 \
		--override-cycles "U7N1Y93;I8;I8;U7N1Y93" \
		--samplesheet-version "v1"


apptainer run \
	-B ${GITHUB_REPOSITORY_LOCAL_PATH}/test/infoFile.tsv:${INFO_INPUT_FILE_CONTAINER} \
	docker://inpred/samplesheet_generator:latest bash

Apptainer> testRunID="191206_NB501498_0174_AHWCNMBGXC"
Apptainer> python3 samplesheet_generator.py \
		--run-id ${testRunID} \
		--index-type simple \
		--index-length 8 \
		--investigator-name "Name (InPreD node)" \
		--experiment-name "OUS pathology test run" \
		--input-info-file ${INFO_INPUT_FILE_CONTAINER} \
		--read-length-1 101 \
		--read-length-2 101 \
		--adapter-read-1 "AGATCGGAAGAGCACACGTCTGAACTCCAGTCA" \
		--adapter-read-2 "AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT" \
		--adapter-behavior "trim" \
		--minimum-trimmed-read-length 35 \
		--mask-short-reads 22 \
		--override-cycles "U7N1Y93;I8;I8;U7N1Y93" \
		--samplesheet-version "v1"
```
