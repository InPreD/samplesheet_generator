import pytest
import generator.cli


@pytest.mark.parametrize(
	"test_input, expected_output", 
	[
		('', False),
		('na', False),
		('NA', False),
		('string', True)]
	]
)

def test_provided(test_input, expected_output):
	assert provided(test_input) == expected_output
