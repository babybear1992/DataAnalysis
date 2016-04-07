# module for parse the html
import BeautifulSoup
# model we wrote to get the html
import gethtml

# build a function to get the article text
def getArticleText(webtext):
    articletext = ""
    soup = BeautifulSoup.BeautifulSoup(webtext)
    # build the articleBody by findall <p> tag with articleBody.
    for tag in soup.findAll('p', attrs={"itemprop":"articleBody"}):
        articletext += tag.contents[0]
        print tag.contents[0]
    # print the article text and return it for key word gerenrate
    return articletext


# build a function to get the article by url
def getArticle(url):
    htmltext = gethtml.getHtmlText(url)
    return getArticleText(htmltext)
# build a function to extract the top30 words 
# that with high occurance frequency
def Keywords(articletext):
# build empty dictionary to store commnwords from the file
    commonDict = {}
# we wrote a plain text file to store the commonwords
    commonDict = open("CommonWords").read().split('\n')
# build empty dictionary to store words
    wordDict = {}
    wordList = articletext.lower().split()
# usually the commonwords may not provide us valuable information,
# so we need to extract them from the article and dig out what the
# article really wants to tell us
    for word in wordList:
        if word not in commonDict and word.isalnum() :
            if word not in wordDict:
                wordDict[word] = 1
            if word in wordDict:
                wordDict[word] += 1
# find the top 30 words, which would have larger 
# possibility of key values of the article.
    top_words = sorted(wordDict.items(),key = lambda (key,value):(value,key), reverse=True)[0:30]
# print the results
    for w in top_words:
        print w[0]



