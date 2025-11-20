-- AlterTable: Adicionar campos para ajuste automático de valor e justificativa de rejeição
-- IMPORTANTE: Esta migration apenas ADICIONA colunas. Nenhum dado será perdido.

-- Adicionar campo valorAprovado (valor após ajuste automático)
ALTER TABLE "guia_procedimentos" ADD COLUMN IF NOT EXISTS "valorAprovado" DOUBLE PRECISION;

-- Adicionar campo motivoRejeicao (justificativa obrigatória para rejeições)
ALTER TABLE "guia_procedimentos" ADD COLUMN IF NOT EXISTS "motivoRejeicao" TEXT;

-- Adicionar campo categoriaRejeicao (categoria da rejeição)
ALTER TABLE "guia_procedimentos" ADD COLUMN IF NOT EXISTS "categoriaRejeicao" TEXT;

-- Comentários nas colunas para documentação
COMMENT ON COLUMN "guia_procedimentos"."valorAprovado" IS 'Valor após ajuste automático ao valor contratual. NULL se não houve ajuste.';
COMMENT ON COLUMN "guia_procedimentos"."motivoRejeicao" IS 'Justificativa obrigatória fornecida pelo auditor ao rejeitar procedimento.';
COMMENT ON COLUMN "guia_procedimentos"."categoriaRejeicao" IS 'Categoria da rejeição (ex: VALOR_DIVERGENTE, FORA_PACOTE, DUT_NAO_CONFORME).';
