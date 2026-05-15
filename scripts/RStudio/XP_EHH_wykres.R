library(data.table)
library(ggplot2)

Pv_Tr <- fread("C:/Users/kjlis/Desktop/Pv_Tr.norm")
Tr_Idt_1 <- fread("C:/Users/kjlis/Desktop/Tr_Idt_1.norm")
Tr_SS_1 <- fread("C:/Users/kjlis/Desktop/Tr_SS_1.norm")
Idt_1vs2 <- fread("C:/Users/kjlis/Desktop/Idt_1vs2.norm")
SS_1vs2 <- fread("C:/Users/kjlis/Desktop/SS_1vs2.norm")

Pv_Tr$norm_xpehh <- as.numeric(Pv_Tr$norm_xpehh)
Tr_Idt_1$norm_xpehh <- as.numeric(Tr_Idt_1$norm_xpehh)
Tr_SS_1$norm_xpehh <- as.numeric(Tr_SS_1$norm_xpehh)
Idt_1vs2$norm_xpehh <- as.numeric(Idt_1vs2$norm_xpehh)
SS_1vs2$norm_xpehh <- as.numeric(SS_1vs2$norm_xpehh)

Pv_Tr <- Pv_Tr[!is.na(norm_xpehh)]
Tr_Idt_1 <- Tr_Idt_1[!is.na(norm_xpehh)]
Tr_SS_1 <- Tr_SS_1[!is.na(norm_xpehh)]
Idt_1vs2 <- Idt_1vs2[!is.na(norm_xpehh)]
SS_1vs2 <- SS_1vs2[!is.na(norm_xpehh)]

ggplot(SS_1vs2, aes(x=norm_xpehh)) +
  geom_histogram(
    bins=100,
    color="black",
    fill="mediumturquoise"
  ) +
  theme_bw() +
  labs(
    x="Normalized XP-EHH",
    y="Count",
    title="Distribution of XP-EHH scores (SS I vs. SS II)"
  )