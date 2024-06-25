/**
 * @author: Flavio Melo
 * @email: flaviomelo17@gmail.com
 * @date: 2024-06-10
 */


public class DocumentValidator {
     // Chama o metodo de validação correto de acordo com o tipo de registro
    public static void validator(List<SObject> toValide, Id pessoaFisicaRecordTypeId, Id pessoaJuridicaRecordTypeId) {
        for (SObject inValidation : toValide) {
            Id recordTypeId = (Id)inValidation.get('RecordTypeId');
            
            if (recordTypeId == pessoaFisicaRecordTypeId) {
                validaCPF(inValidation);
            } else if (recordTypeId == pessoaJuridicaRecordTypeId) {
                validaCNPJ(inValidation);
            }
        }
    }
    
    // Caso o tipo seja pessoa física
    private static void validaCPF(SObject record) {
        String[] invalidCpfs = new String[]{'00000000000', '11111111111', '22222222222', '33333333333', '44444444444', '55555555555', '66666666666', '77777777777', '88888888888', '99999999999'};
            String cpf = (String)record.get('CPF__c');
        // Verifica se o campo CPF não está vazio ou possui um número invalido de caracteres
        if (String.isBlank(cpf) || cpf.length() != 11) {
            record.addError('Documento Inválido.');
            return;
        }
        // Regex simples para remover possiveis caracteres não numericos
        cpf = cpf.replaceAll('[^0-9]', '');
        // Verifica se o CPF não está na lista dos invalidos
        if (invalidCpfs.contains(cpf)) {
            record.addError('Documento Inválido.');
        }
        if (!isValidCPF(cpf)) {
            record.addError('Documento Inválido.');
        }
    }
    // Calculos com base no site: https://www.campuscode.com.br/conteudos/o-calculo-do-digito-verificador-do-cpf-e-do-cnpj
    private static Boolean isValidCPF(String cpf) {
        
        Integer soma = 0;
        Integer digito1;
        Integer digito2;
        
        if (cpf == null) {
            return false;
        }
        
        // multiplica os digitos pela sequência decrescente de 10 à 2 e soma o resultado
        for (Integer i = 0; i < 9; i++) {
            soma += Integer.valueOf(cpf.substring(i, i+1)) * (10 - i);
        }
        // Obtem o modulo da divisão para o primeiro digito verificador
        Integer resto = Math.mod((soma * 10), 11);
        if(resto == 10 || resto == 11)
        {
            digito1 = 0;
        }
        else
        {
            digito1 = resto;
        }        
        soma = 0;
        for (Integer i = 0; i < 10; i++) {
            soma += Integer.valueOf(cpf.substring(i, i+1)) * (11 - i);
        }
        // Obtem o modulo da divisão para o segundo digito verificador
        resto = Math.mod((soma * 10), 11);
        if(resto == 10 || resto == 11)
        {
            digito2 = 0;
        }
        else
        {
            digito2 = resto;
        }
        // verifica se os digitos conferem
        if(digito1 == Integer.valueOf(cpf.substring(9, 10)) && digito2 == Integer.valueOf(cpf.substring(10, 11)))
        {
            return true;
        }
        return false;
    }
    
    // Calculos com base no site: https://www.campuscode.com.br/conteudos/o-calculo-do-digito-verificador-do-cpf-e-do-cnpj
    private static void validaCNPJ(SObject record) {
        String[] invalidCnpjs = new String[]{
            '00000000000000', '11111111111111', '22222222222222', '33333333333333',
            '44444444444444', '55555555555555', '66666666666666', '77777777777777',
            '88888888888888', '99999999999999'
        };
        String cnpj = (String)record.get('CNPJ__c');
        // Verifica se o campo CPF não está vazio ou possui um número invalido de caracteres
        if (String.isBlank(cnpj)  || cnpj.length() != 14) {
            record.addError('Documento Inválido.');
            return;
        }
        cnpj = cnpj.replaceAll('[^0-9]', '');

        // Verifica se o CPF não está na lista dos invalidos
        if (invalidCnpjs.contains(cnpj)) {
            record.addError('Documento Inválido.');
        }
            
        if (!isValidCNPJ(cnpj)) {
            record.addError('Documento Inválido.');
        }
    }
    
    private static Boolean isValidCNPJ(String cnpj) {
        Integer digito1;
        Integer digito2;
        Integer soma = 0;
        if (cnpj == null) {
            return false;
        }
        // soma os dois blocos com os pesos (invertendo a ordem dos pesos invés do CNPJ)        
        Integer[] peso = new Integer[]{5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2};
            
            for (Integer i = 0; i < 12; i++) {
                soma += Integer.valueOf(cnpj.substring(i, i+1)) * peso[i];
            }
        Integer resto = Math.mod(soma, 11);
        if(resto < 2)
        {
            digito1 = 0;
        }
        else
        {
            digito1 = 11 - resto;
        }
        soma = 0;
        Integer[] peso2 = new Integer[]{6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2};
            for(Integer i = 0; i < 13; i++) {
                soma += Integer.valueOf(cnpj.substring(i, i+1)) * peso2[i];
            }
        resto = Math.mod(soma, 11);
        if(resto < 2)
        {
            digito2 = 0;
        }
        else
        {
            digito2 = 11 - resto;
        }
        
        // verifica se os digitos conferem
        if(digito1 == Integer.valueOf(cnpj.substring(12, 13)) && digito2 == Integer.valueOf(cnpj.substring(13, 14)))
        {
            return true;
        }
        return false;
    }
}