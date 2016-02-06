#/bin/bash

# selected with: //a[contains(text(), 'Proceedings')]/@href

urls=( 
http://www.computer.org/csdl/proceedings/icpc/2013/3092/00/index.html
http://www.computer.org/csdl/proceedings/icpc/2012/1213/00/index.html
http://www.computer.org/csdl/proceedings/icpc/2011/4398/00/index.html
http://www.computer.org/csdl/proceedings/icpc/2010/4113/00/index.html
http://dblp.uni-trier.de/db/conf/iwpc/icpc2009.html
http://www.computer.org/csdl/proceedings/icpc/2008/3176/00/index.html
http://www.computer.org/csdl/proceedings/icpc/2007/2860/00/index.html
http://www.computer.org/csdl/proceedings/icpc/2006/2601/00/index.html
http://dblp.uni-trier.de/db/conf/iwpc/iwpc2005.html
http://dblp.uni-trier.de/db/conf/iwpc/iwpc2004.html
http://www.computer.org/csdl/proceedings/icpc/2003/1883/00/index.html
http://dblp.uni-trier.de/db/conf/iwpc/iwpc2002.html
http://dblp.uni-trier.de/db/conf/iwpc/iwpc2001.html
http://dblp.uni-trier.de/db/conf/iwpc/iwpc2000.html
http://dblp.uni-trier.de/db/conf/iwpc/iwpc1999.html
http://dblp.uni-trier.de/db/conf/iwpc/iwpc1998.html
http://www.computer.org/csdl/proceedings/wpc/1997/7993/00/index.html
http://www.computer.org/csdl/proceedings/wpc/1996/7283/00/index.html
)

echo "starting"
echo ${#urls[@]}
year=2013
for i in `seq 0 ${#urls[@]}`; do
  url=${urls[$i]}
  echo $i $year $url
  curl $url > "icpc$year.html"
  let year-=1
done
