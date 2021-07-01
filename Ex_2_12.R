#Ex_2_12
#opening the document
dos_passos <- gutenberg_download(6362, mirror="https://gutenberg.pglaf.org/")%>%
  mutate(text, from="latin1",to="UTF-8")%>%
  select(-gutenberg_id) %>%
  rownames_to_column("Line")

#tokenizing the book in words
stopwordseng <- get_stopwords(language="en")
dos_passos_words <- dos_passos %>%
  unnest_tokens(word,text,strip_numeric=T)%>%
  anti_join(stopwordseng,by="word")%>%
  mutate(stem=stem_words(word,language="en"))

#identifying the most common stems in the book
dos_passos_words %>%
  group_by(stem) %>%
  tally() %>%
  top_n(10)%>%
  arrange(-n)

#sentiment analysis

sentimenteng<- get_sentiments("afinn")

dos_passos_words <- dos_passos_words %>%
  left_join(sentimenteng)
View(dos_passos_words)
dos_passos_words %>%
  mutate(Line=as.numeric(Line)) %>%
  group_by(Line) %>%
  summarize(value=sum(value,na.rm=T)) %>%
  arrange(-value) %>%
  slice(1,n())

dos_passos %>%
  filter(Line==126)%>%
  pull(text)#most positive line

dos_passos %>%
  filter(Line==16479)%>%
  pull(text)#most negative line

dos_passos_words %>%
  mutate(Line=as.numeric(Line)) %>%
  group_by(Line) %>%
  summarize(value=sum(value,na.rm=T))%>%
  mutate(value_rolling=rollapply(value,1000,mean,align='right',fill=NA))%>%
  ggplot()+
  geom_line(aes(x=Line,
                y=value_rolling))+
  theme_classic() +
  ylab("Sentiment")
