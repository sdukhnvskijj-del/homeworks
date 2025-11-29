скрипт в generate_data.py:

import os
import pandas as pd

DATA_DIR = "data"
os.makedirs(DATA_DIR, exist_ok=True)

# Метаданные образцов
sample_metadata = pd.DataFrame({
    'sample_id': [f'Sample_{i}' for i in range(1, 7)],
    'cell_type': ['HEK293', 'HeLa', 'HEK293', 'U2OS', 'HeLa', 'Primary'],
    'treatment': ['Control', 'Drug_A', 'Drug_B', 'Control', 'Drug_A', 'Drug_C'],
    'replicate': [1, 1, 1, 2, 2, 1],
    'concentration_uM': [0, 10, 50, 0, 10, 100]
})

# Результаты масс-спектрометрии
mass_spec_results = pd.DataFrame({
    'sample_id': [f'Sample_{i}' for i in [1, 2, 3, 4, 7]],
    'total_proteins': [2450, 2310, 2540, 2480, 2600],
    'unique_peptides': [15200, 14800, 15600, 15400, 16200],
    'contamination_level': [0.02, 0.05, 0.03, 0.01, 0.04]
})

sample_metadata.to_csv(os.path.join(DATA_DIR, "sample_metadata.csv"), index=False)
mass_spec_results.to_csv(os.path.join(DATA_DIR, "mass_spec_results.csv"), index=False)


скрипт в join.R:

library(dplyr)

# Загрузка данных
sample_metadata <- read.csv("data/sample_metadata.csv")
mass_spec_results <- read.csv("data/mass_spec_results.csv")

# Anti left join (только из левой, которых нет в правой)
anti_left <- anti_join(sample_metadata, mass_spec_results, by = "sample_id")
write.csv(anti_left, "data/anti_left.csv", row.names = FALSE)

# Anti right join (только из правой, которых нет в левой)
anti_right <- anti_join(mass_spec_results, sample_metadata, by = "sample_id")
write.csv(anti_right, "data/anti_right.csv", row.names = FALSE)

# Anti outer join (уникальные для каждой стороны образцы)
anti_outer <- bind_rows(anti_left, anti_right)
write.csv(anti_outer, "data/anti_outer.csv", row.names = FALSE)


скрипт в Dockerfile:

FROM r-base:latest

# установить dplyr
RUN R -e "install.packages('dplyr', repos='https://cloud.r-project.org')"

# скопировать R скрипт внутрь образа
COPY join.R /app/join.R

WORKDIR /app

# выполнение скрипта
CMD R -e "cat('dplyr version: ', as.character(packageVersion('dplyr')), '\n')" \
    && Rscript /app/join.R

Код bush:

# 1. Сгенерировать тестовые CSV файлы (./data)
python generate_data.py

# 2. Собрать Docker-образ 
docker build -t r-anti-join .

# 3. Запустить контейнер с монтированием папки data
docker run -v $(pwd)/data:/app/data r-anti-join