import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// El provider consigue la información de la lista de vídeos de YT a partir del ID de la película
final FutureProviderFamily<List<Video>, int> videosFromMovieProvider = FutureProvider.family((ref, int movieId){
  final movieRepository = ref.watch(movieRepositoryProvider);
  return movieRepository.getYoutubeVideosById(movieId);
});


class VideosFromMovie extends ConsumerWidget {

  final int movieId;

  const VideosFromMovie({super.key, required this.movieId});

  @override
  Widget build(BuildContext context ,WidgetRef ref) {
    
    final videosFromMovie = ref.watch(videosFromMovieProvider(movieId));
    
    return videosFromMovie.when(
      data: ( videos ) => _VideosList(videos: videos), 
      error: (_, __) => const Center(child: Text("Error, no se encontraron vídeos de la película"),), 
      loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2,),)
    );
  }
}

class _VideosList extends StatelessWidget {

  final List<Video> videos;

  const _VideosList({ required this.videos });

  @override
  Widget build(BuildContext context) {
    
    if(videos.isEmpty){
      return const SizedBox();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text("Vídeo de  la película", style: TextStyle(fontSize: 20, ),),
        ),

        // Reproductor de YT
        _YoutubeVideoPlayer(youtubeId: videos.first.youtubeKey, name: videos.first.name),

        const Divider( height: 20, indent: 10, endIndent: 10,),

      ],
    );
  }
}


class _YoutubeVideoPlayer extends StatefulWidget {

  final String youtubeId;
  final String name;

  const _YoutubeVideoPlayer({ required this.youtubeId, required this.name });
  
  @override
  State<_YoutubeVideoPlayer> createState() => _VideoPlayerState();
}


class _VideoPlayerState extends State<_YoutubeVideoPlayer>{
  
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: widget.youtubeId, //Obtien el ID del video de YT
      flags: const YoutubePlayerFlags(
        hideThumbnail: false,
        showLiveFullscreenButton: false,
        mute: false,
        autoPlay: false,
        disableDragSeek: true,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: false,
      )
    );
    

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.name),
          YoutubePlayer(
            controller: _controller,
          
          )
        ],
      ),
    );
  }

}