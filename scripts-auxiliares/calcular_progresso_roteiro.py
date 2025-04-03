# Autor: JacivaldoCarvalho
# Data: 2025-04-03
# Descrição: Script para automatizar o cálculo de horas totais, progresso e horas estudadas
# baseado no progresso dos módulos de um curso.

# Estrutura de dados com o nome dos módulos e suas respectivas durações (em horas)
curso = {
    "Fundamentos do Azure e Governança": [5.15, 0],  # [total de horas, horas estudadas]
    "GitHub e Automação": [35.12, 0],
    "GitHub Copilot": [8.88, 0],
    "DevOps & Automação": [4.18, 0],
    "Segurança Avançada e Conformidade": [15.33, 0],
    "Kubernetes e Contêineres no Azure": [11.75, 0],
    "Monitoramento e Observabilidade": [6.58, 0],
    "Engenharia de Confiabilidade de Sites (SRE)": [29.52, 0],
    "Introduza o DevOps Dojo": [2.00, 0],
}


def marcar_como_concluido(modulo, horas_estudadas):
    """
    Marca um módulo como concluído e atualiza o progresso.
    :param modulo: Nome do módulo a ser marcado como concluído
    :param horas_estudadas: Número de horas do módulo estudadas
    """
    if modulo in curso:
        curso[modulo][1] = horas_estudadas
        print(f"Módulo '{modulo}' marcado como concluído com {horas_estudadas} horas estudadas.")
    else:
        print(f"Erro: Módulo '{modulo}' não encontrado.")


def calcular_total_de_horas():
    """
    Calcula o total de horas do curso.
    """
    total_horas = sum([modulo[0] for modulo in curso.values()])
    return total_horas


def calcular_total_estudado():
    """
    Calcula o total de horas estudadas.
    """
    total_estudado = sum([modulo[1] for modulo in curso.values()])
    return total_estudado


def calcular_progresso():
    """
    Calcula a porcentagem de progresso do curso.
    """
    total_horas = calcular_total_de_horas()
    total_estudado = calcular_total_estudado()
    progresso = (total_estudado / total_horas) * 100
    return progresso


def mostrar_status():
    """
    Mostra o status do curso, incluindo total de horas, horas estudadas e progresso.
    """
    total_horas = calcular_total_de_horas()
    total_estudado = calcular_total_estudado()
    progresso = calcular_progresso()

    print("\n--- Status do Curso ---")
    print(f"Total de horas a cumprir: {total_horas:.2f} horas")
    print(f"Total de horas estudadas: {total_estudado:.2f} horas")
    print(f"Progresso concluído: {progresso:.2f}%")
    print("-----------------------")


# Exemplo de uso do script
marcar_como_concluido("Fundamentos do Azure e Governança", 5.15)  # Módulo completo com 5.15 horas
#marcar_como_concluido("GitHub e Automação", 35.12)
#marcar_como_concluido("GitHub Copilot", 8.88)
#marcar_como_concluido("DevOps & Automação", 4.18)
#marcar_como_concluido("Segurança Avançada e Conformidade", 15.33)
#marcar_como_concluido("Kubernetes e Contêineres no Azure", 11.75)
#marcar_como_concluido("Monitoramento e Observabilidade", 6.58)
#marcar_como_concluido("Engenharia de Confiabilidade de Sites (SRE)", 29.52)
#marcar_como_concluido("Introduza o DevOps Dojo", 2.00)
# Outros módulos podem ser marcados como concluídos conforme o progresso
mostrar_status()
