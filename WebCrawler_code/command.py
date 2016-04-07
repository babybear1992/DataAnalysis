# import two modules we've built in other two files
import gethtml
import articletext

# type a link from NewYorkTimes
url1='http://www.nytimes.com/2015/12/18/us/san-bernardino-enrique-marquez-charges-justice-department.html?hp&action=click&pgtype=Homepage&clickSource=story-heading&module=first-column-region&region=top-news&WT.nav=top-news&_r=0'
url2="http://www.nytimes.com/2015/12/18/opinion/horror-stories-from-new-york-state-prisons.html?action=click&pgtype=Homepage&clickSource=story-heading&module=opinion-c-col-left-region&region=opinion-c-col-left-region&WT.nav=opinion-c-col-left-region"
url3="http://www.nytimes.com/2015/12/18/opinion/freddie-gray-and-the-meaning-of-justice.html?ribbon-ad-idx=3&rref=opinion&module=Ribbon&version=context&region=Header&action=click&contentCollection=Opinion&pgtype=article"
url4="http://www.nytimes.com/2015/03/01/nyregion/attica-prison-infamous-for-bloodshed-faces-a-reckoning-as-guards-go-on-trial.html?action=click&contentCollection=Opinion&module=RelatedCoverage&region=Marginalia&pgtype=article"
url5="http://www.nytimes.com/politics/first-draft/2015/12/17/ted-cruzs-new-data-strategy-here-comes-santa-claus/"
url6='http://www.nytimes.com/2015/12/19/us/politics/conservative-ire-grows-over-marco-rubios-past-on-immigration.html?hpw&rref=us&action=click&pgtype=Homepage&module=well-region&region=bottom-well&WT.nav=bottom-well'
url7='http://www.nytimes.com/2015/12/18/us/politics/marco-rubio-wavers-on-how-hard-to-compete-in-early-primaries.html?action=click&contentCollection=Politics&module=RelatedCoverage&region=Marginalia&pgtype=article'
url='http://www.nytimes.com/2015/12/19/us/congress-spending-bill.html?action=click&contentCollection=Politics&module=MostPopularFB&version=Full&region=Marginalia&src=me&pgtype=article'
url9="http://www.nytimes.com/2015/12/19/us/politics/conservative-ire-grows-over-marco-rubios-past-on-immigration.html?ribbon-ad-idx=3&rref=politics&module=Ribbon&version=context&region=Header&action=click&contentCollection=Politics&pgtype=article"
url10='http://www.nytimes.com/2015/12/18/us/politics/jeb-bush-sensing-momentum-after-debate-zeroes-in-on-donald-trump.html?ribbon-ad-idx=3&rref=politics&module=Ribbon&version=context&region=Header&action=click&contentCollection=Politics&pgtype=article'

article=articletext.getArticle(url)
articletext.Keywords(article)