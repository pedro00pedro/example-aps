class Message {
  String nomeRemetente;
  int tipo;
  String corpoMensagem;
  String msgId;
  String userId;
  Message(String nomeRemetente, int tipo, String corpoMensagem, String msgId,
      String userId) {
    this.corpoMensagem = corpoMensagem;
    this.nomeRemetente = nomeRemetente;
    this.tipo = tipo;
    this.msgId = msgId;
    this.userId = userId;
  }

  String getTipoString() {
    String tipoString = "";
    switch (tipo) {
      case 1:
        tipoString = "Jogos";
        break;
      case 2:
        tipoString = "Noticias";
        break;
      case 3:
        tipoString = "Estudo";
        break;
      case 4:
        tipoString = "Social";
        break;
    }
    return tipoString;
  }
}
