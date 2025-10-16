#1Скопируйте код выше и создайте объект motifs2

motifs2 <- matrix(c(
  "a", "C", "g", "G", "T", "A", "A", "t", "t", "C", "a", "G",
  "t", "G", "G", "G", "C", "A", "A", "T", "t", "C", "C", "a",
  "A", "C", "G", "t", "t", "A", "A", "t", "t", "C", "G", "G",
  "T", "G", "C", "G", "G", "G", "A", "t", "t", "C", "C", "C",
  "t", "C", "G", "a", "A", "A", "A", "t", "t", "C", "a", "G",
  "A", "C", "G", "G", "C", "G", "A", "a", "t", "T", "C", "C",
  "T", "C", "G", "t", "G", "A", "A", "t", "t", "a", "C", "G",
  "t", "C", "G", "G", "G", "A", "A", "t", "t", "C", "a", "C",
  "A", "G", "G", "G", "T", "A", "A", "t", "t", "C", "C", "G",
  "t", "C", "G", "G", "A", "A", "A", "a", "t", "C", "a", "C"
), nrow = 10, byrow = TRUE)

#2Преобразуйте матрицу в верхний регистр (toupper())

motifs2_new <- toupper(motifs2)

#3Постройте COUNT-матрицу и PROFILE-матрицу (через apply() и factor())
profile <- apply(motifs2_new, 2, function(x) {
  counts <- table(factor(x, levels = c("A", "C", "G", "T")))
  counts / sum(counts)
})
#4Используя свою функцию scoreMotifs(), вычислите score для motifs2
motifs2 <- tolower(motifs2)

# Функция для создания PROFILE-матрицы (повторение для ясности)
create_profile_matrix <- function(motifs) {
  count_matrix <- apply(motifs, 2, function(column) {
    table(factor(column, levels = c("a", "c", "g", "t")))
  })
  count_matrix <- matrix(as.numeric(count_matrix), nrow = 4, byrow = FALSE)
  rownames(count_matrix) <- c("A", "C", "G", "T")
  colnames(count_matrix) <- 1:ncol(motifs)
  
  profile_matrix <- apply(count_matrix, 2, function(column) {
    column / sum(column)
  })
  return(profile_matrix)
}

# Создаем PROFILE-матрицу
profile_matrix <- create_profile_matrix(motifs2)

# Пример функции scoreMotifs() (нужно адаптировать под вашу реальную функцию, если она есть)
scoreMotifs <- function(motifs, profile_matrix, background_probs = c(0.25, 0.25, 0.25, 0.25)) {
  # background_probs: вероятности нуклеотидов в случайной последовательности
  
  scores <- apply(motifs, 1, function(motif) { # Применяем к каждой строке (мотиву)
    score <- 0
    for (i in 1:length(motif)) {
      nucleotide <- motif[i]
      # Определяем индекс нуклеотида
      index <- which(c("a", "c", "g", "t") == nucleotide)
      # Добавляем небольшой псевдосчет, чтобы избежать log(0)
      profile_prob <- profile_matrix[index, i] + 0.0001
      background_prob <- background_probs[index]
      # Вычисляем log-odds score и суммируем
      score <- score + log2(profile_prob / background_prob)
    }
    return(score)
  })
  return(scores)
}

# Вычисляем scores для motifs2
scores <- scoreMotifs(motifs2, profile_matrix)

print("Scores для motifs2:")
print(scores)
#5 Реализуйте и протестируйте функцию getConsensus() на этой матрице для получения консенсусной последовательности
motifs2 <- tolower(motifs2)

# Функция для получения консенсусной последовательности
getConsensus <- function(motifs) {
  # 1. Создаем count-матрицу (используем код из предыдущих ответов)
  count_matrix <- apply(motifs, 2, function(column) {
    table(factor(column, levels = c("a", "c", "g", "t")))
  })
  count_matrix <- matrix(as.numeric(count_matrix), nrow = 4, byrow = FALSE)
  rownames(count_matrix) <- c("A", "C", "G", "T")
  colnames(count_matrix) <- 1:ncol(motifs)
  
  # 2. Находим наиболее частый нуклеотид в каждой позиции
  consensus <- apply(count_matrix, 2, function(column) {
    nucleotides <- c("A", "C", "G", "T")
    most_frequent_index <- which.max(column)
    return(nucleotides[most_frequent_index])
  })
  
  # 3. Объединяем нуклеотиды в консенсусную последовательность
  consensus_sequence <- paste(consensus, collapse = "")
  
  return(consensus_sequence)
}

# Тестируем функцию getConsensus()
consensus_sequence <- getConsensus(motifs2)

print("Консенсусная последовательность:")
print(consensus_sequence)
#6 Постройте barplot частот нуклеотидов для любого выбранного столбца


# Выбираем первый столбец (column = 1)
selected_column <- count_matrix[, 1]

# Создаем barplot
barplot(selected_column,
        col = "skyblue",
        main = "Частоты нуклеотидов в 1-м столбце",
        xlab = "Нуклеотид",
        ylab = "Частота",
        names.arg = c("A", "C", "G", "T"))



# Преобразование в нижний регистр
motifs2 <- tolower(motifs2)

# Создаем COUNT-матрицу (как в предыдущих примерах)
count_matrix <- apply(motifs2, 2, function(column) {
  table(factor(column, levels = c("a", "c", "g", "t")))
})
count_matrix <- matrix(as.numeric(count_matrix), nrow = 4, byrow = FALSE)
rownames(count_matrix) <- c("A", "C", "G", "T")
colnames(count_matrix) <- 1:ncol(motifs2)

# Выбираем первый столбец (column = 1)
selected_column <- count_matrix[, 1]

# Создаем barplot
barplot(selected_column,
        col = "skyblue",
        main = "Частоты нуклеотидов в 1-м столбце",
        xlab = "Нуклеотид",
        ylab = "Частота",
        names.arg = c("A", "C", "G", "T"))

