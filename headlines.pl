#!/usr/bin/perl

use 5.010;

my @elements;
my @matches;

#How to use the file: perl headlines.pl < <the input file to analyze>

#Extracting the data from the file.
while ( defined( $line = <STDIN> ) ) {

	#We match <h\d+>
	$_ = $line;
	push( @matches, m/<h(\d+)>(.+?)<\/h\g{1}>/g );
}

print "Finished extracting the headlines...\n";

print getContextMenu( 'Table Name', @matches );

sub getContextMenu {
	my ( $contextMenuTitle, @itemsArray ) = @_;
	my $returnText = '<div id="toc_container">' . "<p class=\"toc_title\">$contextMenuTitle <span class=\"toc_toggle\">[ <a>hide</a> ]</span></p><ul class=\"toc_list\">";

	( $finalIndex, $returnedText ) =
	  getContextMenuRecursive( 0, 1, '', @itemsArray );
	$returnText .= $returnedText;
	$returnText .= '</ul></div>';
}

sub getContextMenuRecursive {
	my ( $currentIndex, $currentDepth, @array, $prefixText );
	( $currentIndex, $currentDepth, $prefixText, @array ) = @_;
	my $returnText = "<li>";
	my ($i);
	$i = 1;
	my $lastPrefix = $prefixText . $i;
  CONTEXT: {

		while ( $currentIndex < $#array + 1 ) {
			my $firstNumber = $array[$currentIndex];
			my $firstTitle  = $array[ $currentIndex + 1 ];
			if ( $firstNumber < $currentDepth ) {
				last CONTEXT;
			}
			elsif ( $firstNumber > $currentDepth ) {
				( $currentIndex, $returnedText ) = getContextMenuRecursive(
					$currentIndex,
					$currentDepth + 1,
					$lastPrefix . '.', @array
				);
				$returnText .= "<ul>" . $returnedText . "</ul>\n";
			}
			else {
				if ( $i > 1 ) {
					$returnText .= "</li><li>";
				}
				$returnText .=
				  "<a><span class=\"toc_number toc_depth_$currentDepth\">" . $prefixText . $i . "</span>" . "\" $firstTitle\"" . "</a>\n";
				$lastPrefix = $prefixText . $i;
				$i++;
				$currentIndex += 2;
			}
		}
	}
	( $currentIndex, $returnText . "</li>" );
}

sub getMenuText_old {

	# initializes the input parameters.
	my ( $currentDepth, @array, $prefixText );
	( $currentDepth, $prefixText, @array ) = @_;
	my $returnText = "<ul>\n";
	print "Calling getMenuText with: $currentDepth, $prefixText, $#array\n";
	my ($i);
	$i = 1;
	my $lastPrefix = $prefixText . $i;
  CONTEXT: {

		while ( $#array >= 2 ) {

			my $firstNumber = $array[0];
			my $firstTitle  = $array[1];
			if ( $firstNumber < $currentDepth ) {
				print "Break...\n";
				last CONTEXT;
			}
			elsif ( $firstNumber > $currentDepth ) {
				print "Recursive call with i = $i\n";
				$returnText .=
				  getMenuText( $currentDepth + 1, $lastPrefix . '.', @array );
			}
			else {
				print "Augment text\n";
				$returnText .=
				    "<li><span>"
				  . $prefixText
				  . $i
				  . "</span>"
				  . $firstTitle
				  . "</li>\n";
				$lastPrefix = $prefixText . $i;
				$i++;
			}
			shift(@array);
			shift(@array);
		}
	}
	$returnText . "</ul>";
}

sub getFlatMenuText_old {

	# initializes the input parameters.
	my @array = @_;
	my $returnText = "<ul>\n" . getFlatMenuTextContent( 0, 1, '', @array );
	$returnText . "</ul>\n";
}

sub getFlatMenuTextContent_old {

	# initializes the input parameters.
	my ( $currentIndex, $currentDepth, @array, $prefixText );
	( $currentIndex, $currentDepth, $prefixText, @array ) = @_;
	my $returnText;
	my ($i);
	$i = 1;
	my $lastPrefix = $prefixText . $i;
  CONTEXT: {

		while ( $currentIndex < $#array + 1 ) {
			my $firstNumber = $array[$currentIndex];
			my $firstTitle  = $array[ $currentIndex + 1 ];
			if ( $firstNumber < $currentDepth ) {
				print "Break...\n";
				last CONTEXT;
			}
			elsif ( $firstNumber > $currentDepth ) {
				( $currentIndex, $returnedText ) = getFlatMenuTextContent(
					$currentIndex,
					$currentDepth + 1,
					$lastPrefix . '.', @array
				);
				$returnText .= $returnedText;
			}
			else {
				print
"firstNumber = $firstNumber, currentDepth = $currentDepth, array length $#array\n";
				$returnText .=
				    "<li><span>"
				  . $prefixText
				  . $i
				  . "</span>"
				  . $firstTitle
				  . "</li>\n";
				$lastPrefix = $prefixText . $i;
				$i++;
			}
			$currentIndex += 2;
		}
	}
	print "Returning from recursive... Depth: $currentDepth\n";

	( $currentIndex, $returnText );
}

sub getLinearMenuText_old {

	my $compiledText       = '<ul class="toc_list">';
	my @headlinesList      = @_;
	my $lastHeadlineNumber = 1;
	my @headLineBullets    = (1);
	for my $i ( 0 .. $#headlinesList / 2 ) {
		my $headLineNumber = $matches[ 2 * $i ];
		my $headLineName   = $matches[ 2 * $i + 1 ];
		my $numberString =
		  getNextNumberString( $lastHeadlineNumber, $headLineNumber,
			@headLineBullets );

		$compiledText .=
"<li><span>$numberString</span>headlineLevel$headLineNumber'>$headLineName</li>\n";
		$lastHeadlineNumber = $headLineNumber;
	}
	$compiledText;
}

sub getNextNumberString_old {

	# initializes the input parameters.
	my ( $lastHeadlineNumber, $headLineNumber, @headLineBullets );
	( $lastHeadlineNumber, $headLineNumber, @headLineBullets ) = @_;

	if ( $headLineNumber <= $lastHeadlineNumber ) {
		my $returnString =
		  generateNumberString( $headLineNumber, @headLineBullets );
		$headLineBullets[$headLineNumber]++;
		$returnString;
	}
	else {
		while ( $headLineNumber > $lastHeadlineNumber ) {
			if ( $#headLineBullets == $lastHeadlineNumber ) {
				push( @headLineBullets, 1 );
			}
			else {
				$headLineBullets[ $lastHeadlineNumber - 1 ] = 1;
			}
			$lastHeadlineNumber++;
		}

		print "getNextNumberString $lastHeadlineNumber $headLineNumber\n\n";

		my $returnString =
		  generateNumberString( $headLineNumber, @headLineBullets );
		$returnString;
	}

}

sub generateNumberString_old {
	my ( $headLineNumber, @headLineBullets );
	( $headLineNumber, @headLineBullets ) = @_;
	join( '.', @headLineBullets[ 0 .. $headLineNumber - 1 ] );
}

sub getMenuTextWithoutNumbers_old {
	my $matches = shift;

	#Printing out the data... -> Create a sub routine for this later...
	print "\n\nTime to print out html...\n\n===========\n\n";
	print "<div>";
	my $currentIndex = 0;
	for my $i ( 0 .. $#matches / 2 ) {
		my $headLineNumber = $matches[ 2 * $i ];
		my $headLineName   = $matches[ 2 * $i + 1 ];
		if ( $currentIndex < $headLineNumber ) {
			print "<ul class=\'headlineLevel$headLineNumber\'>";
			$currentIndex = $headLineNumber;
		}
		elsif ( $currentIndex > $headLineNumber ) {
			print "</ul>";
			$currentIndex = $headLineNumber;

		}
		print "<li>" . $headLineName . "</li>\n";
	}
	print "</div>\n\n";
	return ( $currentIndex, $headLineName, $headLineNumber );
}
