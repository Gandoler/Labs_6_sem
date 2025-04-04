# Лабораторная работа №6: Алгоритмы генерации и верификации электронной цифровой подписи

## Цель работы

Изучение алгоритмов генерации и верификации электронной цифровой подписи (ЭЦП) и приобретение практических навыков их реализации.

## Теоретические сведения

Электронная цифровая подпись (ЭЦП) представляет собой криптографический механизм для обеспечения целостности, подлинности и аутентичности электронных сообщений. ЭЦП используется для того, чтобы подтвердить авторство и целостность документа, а также обеспечить защиту от подделки.

### Основные функции ЭЦП:
- **Аутентификация**: подтверждение того, что сообщение было подписано именно этим человеком.
- **Целостность**: проверка того, что сообщение не было изменено после его подписания.
- **Неотказуемость**: доказательство авторства в случае спора.

ЭЦП используется в различных криптографических алгоритмах, таких как RSA, DSA, Эль-Гамаль и Шнорр.

### Алгоритм Эль-Гамаля для ЭЦП

Алгоритм Эль-Гамаля является популярным методом для создания и проверки цифровых подписей. Основные этапы работы с ЭЦП Эль-Гамаля:

1. **Генерация ключей**:
    - Генерируется большое простое число \(p\) и генератор \(g\).
    - Выбирается секретный ключ \(x\) (случайное число).
    - Открытый ключ \(y\) вычисляется как \(y = g^x \mod p\).

2. **Подпись сообщения**:
    - Генерируется случайное число \(k\), взаимно простое с \(p-1\).
    - Вычисляется \(r = g^k \mod p\).
    - Вычисляется \(s = (message - x \cdot r) \cdot k^{-1} \mod (p-1)\).
    - Подпись \(r\) и \(s\) отправляются получателю.

3. **Проверка подписи**:
    - Получатель вычисляет \(v1 = y^r \cdot r^s \mod p\) и \(v2 = g^{message} \mod p\).
    - Если \(v1 = v2\), подпись считается действительной.

## Алгоритм Эль-Гамаля: Реализация

В данной лабораторной работе был реализован алгоритм Эль-Гамаля для подписи и проверки подписи сообщений.

### Код программы

Программа состоит из двух основных частей:
1. **Генерация ключей**:
    - Генерируется случайное простое число \(p\), генератор \(g\) и секретный ключ \(x\).
    - Вычисляется открытый ключ \(y = g^x \mod p\).
  
2. **Подпись и верификация**:
    - Сообщение подписывается с использованием секретного ключа.
    - Проверка подписи выполняется с использованием открытого ключа.

### Код генерации ключей и подписи

```csharp
public static void GenerateKeys(int bitLength = 512)
{
    p = PrimeGen.GeneratePrime(bitLength);
    g = PrimeGen.GenerateGenerator(p);
    x = PrimeGen.RandomBigInteger(2, p - 2);
    y = BigInteger.ModPow(g, x, p);
}

public static (BigInteger, BigInteger) Sign(BigInteger message)
{
    BigInteger k;
    do
    {
        k = PrimeGen.RandomBigInteger(2, p - 2);
    } while (BigInteger.GreatestCommonDivisor(k, p - 1) != 1);
    
    BigInteger r = BigInteger.ModPow(g, k, p);
    BigInteger s = ((message - x * r) * PrimeGen.ModInverse(k, p - 1)) % (p - 1);
    if (s < 0) s += p - 1;
    
    return (r, s);
}
```

### Код проверки подписи

```csharp
public static bool Verify(BigInteger message, BigInteger r, BigInteger s)
{
    if (r <= 0 || r >= p || s <= 0 || s >= p - 1) return false;

    BigInteger v1 = BigInteger.ModPow(y, r, p) * BigInteger.ModPow(r, s, p) % p;
    BigInteger v2 = BigInteger.ModPow(g, message, p);

    return v1 == v2;
}
```

### Пример выполнения программы

```csharp
static void Main()
{
    ElGamalSignature.GenerateKeys();
    BigInteger message = new BigInteger(123456);
    var signature = ElGamalSignature.Sign(message);
    Console.WriteLine($"Message: {message}");
    Console.WriteLine($"Signature: r = {signature.Item1}, s = {signature.Item2}");
    Console.WriteLine($"Verification: {ElGamalSignature.Verify(message, signature.Item1, signature.Item2)}");

    BigInteger message2 = new BigInteger(123456);
    var signature2 = ElGamalSignature.Sign(message2);
    message2 = new BigInteger(1234523456); // изменяем сообщение
    Console.WriteLine($"Message: {message2}");
    Console.WriteLine($"Signature: r = {signature.Item1}, s = {signature.Item2}");
    Console.WriteLine($"Verification: {ElGamalSignature.Verify(message2, signature.Item1, signature.Item2)}");
}
```

### Результат выполнения программы

- Программа сначала генерирует ключи и подписывает сообщение.
- Затем проверяется подпись на целостность и подлинность.
- В случае изменения сообщения подпись становится недействительной.

