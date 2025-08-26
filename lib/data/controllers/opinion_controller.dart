import 'dart:convert';
import 'package:http/http.dart' as http;
import '../global_data.dart';
import '../../api.dart';
import '../../logs.dart';
import '../entities/opinion.dart';

class OpinionController {
    static Future<bool> createOpinion(Opinion opinion) async {
        try {
            http.Response response = await OpinionsApi.createOpinion(opinion);
            
            if (response.statusCode == 200 || response.statusCode == 201) {
                await traceInfo('OpinionController', 'Opinion created successfully');
                return true;
            } else {
                await traceError('OpinionController', 'Failed to create opinion: ${response.statusCode} - ${response.body}');
                return false;
            }
        } catch (error) {
            await traceError('OpinionController', 'Error creating opinion: $error');
            return false;
        }
    }

    static Future<Opinion?> getOpinion(String dishId) async {
        try {
            String clientId = GlobalData.client.clientId;
            http.Response response = await OpinionsApi.getOpinion(clientId, dishId);
            
            if (response.statusCode == 200) {
                Map<String, dynamic> json = jsonDecode(response.body);
                Opinion? opinion = Opinion.fromJson(json);
                
                if (opinion != null) {
                    await traceInfo('OpinionController', 'Retrieved opinion for dish $dishId');
                } else {
                    await traceError('OpinionController', 'Failed to parse opinion for dish $dishId');
                }
                return opinion;
            } else {
                await traceError('OpinionController', 'Failed to get opinion: ${response.statusCode} - ${response.body}');
                return null;
            }
        } catch (error) {
            await traceError('OpinionController', 'Error getting opinion: $error');
            return null;
        }
    }

    static Future<List<Opinion>> getOpinionsByClient() async {
        try {
            String clientId = GlobalData.client.clientId;
            http.Response response = await OpinionsApi.getOpinionsByClient(clientId);
            
            if (response.statusCode == 200) {
                List<dynamic> jsonList = jsonDecode(response.body);
                List<Opinion> opinions = jsonList
                    .map((json) => Opinion.fromJson(json))
                    .where((opinion) => opinion != null)
                    .cast<Opinion>()
                    .toList();
                
                await traceInfo('OpinionController', 'Retrieved ${opinions.length} opinions');
                return opinions;
            } else {
                await traceError('OpinionController', 'Failed to get opinions: ${response.statusCode} - ${response.body}');
                return [];
            }
        } catch (error) {
            await traceError('OpinionController', 'Error getting opinions: $error');
            return [];
        }
    }

    static Future<List<Opinion>> getOpinionsByWine(String wineId) async {
        try {
            List<Opinion> allOpinions = await getOpinionsByClient();
            List<Opinion> wineOpinions = allOpinions.where((opinion) => opinion.wineId == wineId).toList();
            
            await traceInfo('OpinionController', 'Retrieved ${wineOpinions.length} opinions for wine $wineId');
            return wineOpinions;
        } catch (error) {
            await traceError('OpinionController', 'Error getting opinions by wine: $error');
            return [];
        }
    }

    static Future<List<Opinion>> getOpinionsByDish(String dishId) async {
        try {
            List<Opinion> allOpinions = await getOpinionsByClient();
            List<Opinion> dishOpinions = allOpinions.where((opinion) => opinion.dishId == dishId).toList();
            
            await traceInfo('OpinionController', 'Retrieved ${dishOpinions.length} opinions for dish $dishId');
            return dishOpinions;
        } catch (error) {
            await traceError('OpinionController', 'Error getting opinions by dish: $error');
            return [];
        }
    }

    static Future<double> getAverageRatingForWine(String wineId) async {
        try {
            List<Opinion> wineOpinions = await getOpinionsByWine(wineId);
            if (wineOpinions.isEmpty) return 0.0;
            
            double average = wineOpinions.map((o) => o.rate).reduce((a, b) => a + b) / wineOpinions.length;
            return average;
        } catch (error) {
            await traceError('OpinionController', 'Error calculating average rating: $error');
            return 0.0;
        }
    }

    static Future<double> getAverageRatingForDish(String dishId) async {
        try {
            List<Opinion> dishOpinions = await getOpinionsByDish(dishId);
            if (dishOpinions.isEmpty) return 0.0;
            
            double average = dishOpinions.map((o) => o.rate).reduce((a, b) => a + b) / dishOpinions.length;
            return average;
        } catch (error) {
            await traceError('OpinionController', 'Error calculating average rating: $error');
            return 0.0;
        }
    }
}
