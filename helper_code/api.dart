      final response = await http.get(
        Uri.parse('${Config.apiBaseURI}/lessons'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': Config.apiKey,
        },
      );